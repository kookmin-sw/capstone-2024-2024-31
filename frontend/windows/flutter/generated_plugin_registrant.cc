//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"
#include <url_launcher_windows/url_launcher_windows.h>
#include <window_to_front/window_to_front_plugin.h>
#include <file_selector_windows/file_selector_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  WindowToFrontPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowToFrontPlugin"));

  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
}
