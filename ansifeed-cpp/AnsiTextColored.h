// Based on https://gist.github.com/ddovod/be210315f285becc6b0e455b775286e1

// #include <vector>
// #include <string>
// #define IMGUI_DEFINE_MATH_OPERATORS
#include <imgui.h>

namespace ImGui
{
    void TextAnsi(const char* fmt,  ...);
    void TextAnsiColored(const ImVec4& col, const char* fmt, ...);
}
