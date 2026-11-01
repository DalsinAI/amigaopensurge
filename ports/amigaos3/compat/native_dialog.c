#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include <SDL2/SDL.h>
#include <allegro5/allegro_native_dialog.h>

struct ALLEGRO_FILECHOOSER {
    int unused;
};

struct ALLEGRO_TEXTLOG {
    int unused;
};

static bool native_dialog_initialized;

bool al_init_native_dialog_addon(void)
{
    native_dialog_initialized = true;
    return true;
}

bool al_is_native_dialog_addon_initialized(void)
{
    return native_dialog_initialized;
}

void al_shutdown_native_dialog_addon(void)
{
    native_dialog_initialized = false;
}

ALLEGRO_FILECHOOSER *al_create_native_file_dialog(
    const char *initial_path, const char *title, const char *patterns, int mode)
{
    (void)initial_path;
    (void)title;
    (void)patterns;
    (void)mode;
    return calloc(1, sizeof(ALLEGRO_FILECHOOSER));
}

bool al_show_native_file_dialog(
    ALLEGRO_DISPLAY *display, ALLEGRO_FILECHOOSER *dialog)
{
    (void)display;
    (void)dialog;
    return false;
}

int al_get_native_file_dialog_count(const ALLEGRO_FILECHOOSER *dialog)
{
    (void)dialog;
    return 0;
}

const char *al_get_native_file_dialog_path(
    const ALLEGRO_FILECHOOSER *dialog, size_t index)
{
    (void)dialog;
    (void)index;
    return NULL;
}

void al_destroy_native_file_dialog(ALLEGRO_FILECHOOSER *dialog)
{
    free(dialog);
}

int al_show_native_message_box(
    ALLEGRO_DISPLAY *display, const char *title, const char *heading,
    const char *text, const char *buttons, int flags)
{
    Uint32 sdl_flags = SDL_MESSAGEBOX_INFORMATION;
    char message[1024];

    (void)display;
    (void)buttons;

    if(flags & ALLEGRO_MESSAGEBOX_ERROR)
        sdl_flags = SDL_MESSAGEBOX_ERROR;
    else if(flags & ALLEGRO_MESSAGEBOX_WARN)
        sdl_flags = SDL_MESSAGEBOX_WARNING;

    snprintf(message, sizeof(message), "%s%s%s",
        heading ? heading : "",
        heading && heading[0] ? "\n\n" : "",
        text ? text : "");

    return SDL_ShowSimpleMessageBox(
        sdl_flags, title ? title : "Open Surge", message, NULL) == 0;
}

ALLEGRO_TEXTLOG *al_open_native_text_log(const char *title, int flags)
{
    (void)title;
    (void)flags;
    return calloc(1, sizeof(ALLEGRO_TEXTLOG));
}

void al_close_native_text_log(ALLEGRO_TEXTLOG *textlog)
{
    free(textlog);
}

void al_append_native_text_log(ALLEGRO_TEXTLOG *textlog, const char *format, ...)
{
    va_list args;

    (void)textlog;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
}
