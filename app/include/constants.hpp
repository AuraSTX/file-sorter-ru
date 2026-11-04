#ifndef CONSTANTS_HPP
#define CONSTANTS_HPP

// Fork builds (file-sorter-ru) override these via compile definitions so the
// rebranded app uses its own name and its own settings/log directory.
#ifdef AI_FILE_SORTER_APP_NAME
constexpr auto APP_NAME = AI_FILE_SORTER_APP_NAME;
#else
constexpr auto APP_NAME = "AI File Sorter";
#endif

#ifdef AI_FILE_SORTER_APP_DIR_NAME
constexpr auto APP_NAME_DIR = AI_FILE_SORTER_APP_DIR_NAME;
#else
constexpr auto APP_NAME_DIR = "AIFileSorter";
#endif

#ifdef AI_FILE_SORTER_INSTANCE_ID
constexpr auto APP_INSTANCE_ID = AI_FILE_SORTER_INSTANCE_ID;
#else
constexpr auto APP_INSTANCE_ID = "dev.hfstudio.AIFileSorter";
#endif

#endif
