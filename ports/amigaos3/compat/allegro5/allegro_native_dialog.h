#ifndef OPEN_SURGE_AMIGAOS3_ALLEGRO_NATIVE_DIALOG_H
#define OPEN_SURGE_AMIGAOS3_ALLEGRO_NATIVE_DIALOG_H

#include <allegro5/allegro.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct ALLEGRO_FILECHOOSER ALLEGRO_FILECHOOSER;
typedef struct ALLEGRO_TEXTLOG ALLEGRO_TEXTLOG;

bool al_init_native_dialog_addon(void);
bool al_is_native_dialog_addon_initialized(void);
void al_shutdown_native_dialog_addon(void);

ALLEGRO_FILECHOOSER *al_create_native_file_dialog(
    const char *initial_path, const char *title, const char *patterns, int mode);
bool al_show_native_file_dialog(
    ALLEGRO_DISPLAY *display, ALLEGRO_FILECHOOSER *dialog);
int al_get_native_file_dialog_count(const ALLEGRO_FILECHOOSER *dialog);
const char *al_get_native_file_dialog_path(
    const ALLEGRO_FILECHOOSER *dialog, size_t index);
void al_destroy_native_file_dialog(ALLEGRO_FILECHOOSER *dialog);

int al_show_native_message_box(
    ALLEGRO_DISPLAY *display, const char *title, const char *heading,
    const char *text, const char *buttons, int flags);

ALLEGRO_TEXTLOG *al_open_native_text_log(const char *title, int flags);
void al_close_native_text_log(ALLEGRO_TEXTLOG *textlog);
void al_append_native_text_log(
    ALLEGRO_TEXTLOG *textlog, const char *format, ...);

enum {
    ALLEGRO_FILECHOOSER_FILE_MUST_EXIST = 1,
    ALLEGRO_FILECHOOSER_SAVE = 2,
    ALLEGRO_FILECHOOSER_FOLDER = 4,
    ALLEGRO_FILECHOOSER_PICTURES = 8,
    ALLEGRO_FILECHOOSER_SHOW_HIDDEN = 16,
    ALLEGRO_FILECHOOSER_MULTIPLE = 32
};

enum {
    ALLEGRO_MESSAGEBOX_WARN = 1 << 0,
    ALLEGRO_MESSAGEBOX_ERROR = 1 << 1,
    ALLEGRO_MESSAGEBOX_OK_CANCEL = 1 << 2,
    ALLEGRO_MESSAGEBOX_YES_NO = 1 << 3,
    ALLEGRO_MESSAGEBOX_QUESTION = 1 << 4
};

enum {
    ALLEGRO_TEXTLOG_NO_CLOSE = 1 << 0,
    ALLEGRO_TEXTLOG_MONOSPACE = 1 << 1
};

#ifdef __cplusplus
}
#endif

#endif
