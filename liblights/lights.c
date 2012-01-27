/*
 * Copyright (C) 2012 Stefan Seidel
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#define LOG_TAG "lights"

#include <cutils/log.h>

#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <hardware/lights.h>
#include <cutils/properties.h>

/******************************************************************************/

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static int max_brightness = 255;
static char brightness_file[PROPERTY_VALUE_MAX] = {'\0'};

char const*const LLP_BRIGHTNESS_FILE = "backlight.brightness_file";
char const*const LLP_MAX_BRIGHTNESS_FILE = "backlight.max_brightness_file";

void init_globals(void)
{
    pthread_mutex_init(&g_lock, NULL);
}

static int write_int(char* path, int value)
{
    int fd;
    static int already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
        char buffer[20];
        int bytes = sprintf(buffer, "%d\n", value);
        int amt = write(fd, buffer, bytes);
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            LOGE("write_int failed to open %s\n", path);
            already_warned = 1;
        }
        return -errno;
    }
}

static int read_int(char* path)
{
    int fd;

    fd = open(path, O_RDONLY);
    if (fd >= 0) {
        char buffer[3];
        int amt = read(fd, buffer, 3);
        close(fd);
        if (amt <= 0) return -errno;
        int ret = -1;
        amt = sscanf(buffer, "%d", &ret);
        return amt == -1 ? -errno : ret;
    } else {
        return -errno;
    }
}

static int rgb_to_brightness16(struct light_state_t const* state)
{
    int color = state->color & 0x00ffffff;
    return ((77*((color>>16)&0x00ff)) + (150*((color>>8)&0x00ff)) + (29*(color&0x00ff)));
}

static int set_light_backlight(struct light_device_t* dev, struct light_state_t const* state)
{
    int err = 0;
    int brightness = rgb_to_brightness16(state) / (65536 / (max_brightness+1));
    LOGV("Setting display brightness to %d",brightness);

    pthread_mutex_lock(&g_lock);
    err = write_int(brightness_file, (brightness));
    pthread_mutex_unlock(&g_lock);

    return err;
}

static int close_lights(struct light_device_t *dev)
{
    if (dev) {
        free(dev);
    }
    return 0;
}


static int open_lights(const struct hw_module_t* module, char const* name, struct hw_device_t** device)
{
    int (*set_light)(struct light_device_t* dev,
            struct light_state_t const* state);

    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name)) {
        set_light = set_light_backlight;
        char max_b_file[PROPERTY_VALUE_MAX] = {'\0'};
        if (property_get(LLP_MAX_BRIGHTNESS_FILE, max_b_file, NULL)) {
            max_brightness = read_int(max_b_file);
        } else {
            LOGE("%s system property not set", LLP_MAX_BRIGHTNESS_FILE);
            return -EINVAL;
        }
        LOGV("Read max display brightness of %d", max_brightness);
        if (max_brightness < 1) {
            max_brightness = 255;
        }
        if (!property_get(LLP_BRIGHTNESS_FILE, brightness_file, NULL)) {
            LOGE("%s system property not set", LLP_BRIGHTNESS_FILE);
            return -EINVAL;
        }
    }
    else {
        return -EINVAL;
    }

    pthread_once(&g_init, init_globals);

    struct light_device_t *dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.close = (int (*)(struct hw_device_t*))close_lights;
    dev->common.module = (struct hw_module_t*)module;
    dev->common.version = 0;
    dev->set_light = set_light;

    *device = (struct hw_device_t*)dev;
    return 0;
}


static struct hw_module_methods_t lights_module_methods = {
    .open =  open_lights,
};

const struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "Generic sysfs liblights implementation",
    .author = "Stefan Seidel",
    .methods = &lights_module_methods,
};
