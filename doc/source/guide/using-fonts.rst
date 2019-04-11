.. _guide-using-fonts:

Using fonts
===========

ImGui is able to load and display fonts. It is capable of handling both
OTF and TTF fonts.

To load and configure fonts you should use the :class:`_FontAtlas` object
available through :class:`_IO.fonts` attribute. Neither :class:`_FontAtlas` nor
:class:`_IO.fonts` are meant to be instantiated by user. You access them
through the :func:`imgui.get_io()` function::

    import imgui

    io = imgui.get_io()


Once you have access to the font atlas you can load custom fonts by
providing path of the OTF or TTF file to the
:meth:`_FontAtlas.add_font_from_file_ttf` method::


    io = imgui.get_io()
    io.fonts.add_font_from_file_ttf(
        font_file_path, font_pixel_size, glyph_ranges
    )

The :meth:`_FontAtlas.add_font_from_file_ttf` acccepts three important
arguments:

* **filename** *(int)*: path to OTF or TTF file
* **size_pixels** *(int)*: font size in pixels
* **glyph_ranges** (:class:`_StaticGlyphRanges`): ranges of glyphs to load from the font file

Once all your fonts are loaded you can rasterize font into texture that will
be later used by your renderer on all widgets containing text. Remember that
core of the ImGui library is completely decoupled from the rendering pipeline.
It means that your renderer implementation is responsible for rendering fonts
from the texture and ImGui only provides the abstract draw calls for rendering
part of the textures and doesn't even know what is actual implementation behind
them.

For OpenGL renderers you can generate texture for all your loaded fonts
using following code::

    import imgui
    from OpenGL import GL as gl

    io = imgui.get_io()

    last_texture = gl.glGetIntegerv(gl.GL_TEXTURE_BINDING_2D)

    width, height, pixels = io.fonts.get_tex_data_as_rgba32()

    font_texture = gl.glGenTextures(1)

    gl.glBindTexture(gl.GL_TEXTURE_2D, font_texture)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)
    gl.glTexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, pixels)

    io.fonts.texture_id = font_texture
    gl.glBindTexture(gl.GL_TEXTURE_2D, last_texture)


Fortunately you don't have to do this all by yourself. Every built-in
integration class from :mod:`imgui.integrations` sub-package provides
:meth:`refresh_font_texture()` that does this for you in a way that is native
for given rendering pipeline.

.. visual-example::
    :introduction: Following example shows how this usually looks in practice:
    :inter: Above code should render following result:
    :auto_layout:
    :height: 100
    :width: 320
    :title: Using custom fonts

    io = imgui.get_io()
    new_font = io.fonts.add_font_from_file_ttf(
        "DroidSans.ttf", 20,
    )
    impl.refresh_font_texture()

    # later in frame code

    imgui.begin("Default Window")

    imgui.text("Text displayed using default font")

    with imgui.font(new_font):
        imgui.text("Text displayed using custom font")

    imgui.end()


High-density screens
--------------------

On some high-density displays like Retina Display fonts may appear blurred.
It's because font sizes are specified in screen size pixels but on high-density
screens actual framebuffer will be much bigger so font texture needs to be
slightly stretched.

In order to curcumvent this effect you can tell ImGui to generate bigger font
 textures and set proper global font scaling factor as on following example::


    import imgui

    io = imgui.get_io()

    # Font scaling factor is display dependent (different displays
    # may have different densities), so you will have to find
    # actual factor on your own
    font_scaling_factor = 2
    font_size_in_pixels = 30

    io.fonts.add_font_from_file_ttf(
        "DroidSans.ttf", font_size_in_pixels * font_scaling_factor
    )
    io.font_global_scale /= font_scaling_factor


So how to relaibly guess required font scaling factor? One of the ways is to
compare window size with size of the actual framebuffer assigned to that
window. Implementation will be different for each rendering library. Here is
one of possible examples for glfw::

    win_w, win_h = glfw.get_window_size(window)
    fb_w, fb_h = glfw.get_framebuffer_size(window)
    font_scaling_factor = max(float(fb_w) / win_w, float(fb_h) / win_h)


If you set global scaling factor then you should also probably clear whole
font atlas before adding any font atlas using :meth:`_FontAtlas.clear`.
Otherwise default built in font that is loaded on imgui startpup will be too
small to read. Its place will be taken by first font you add to the atlas.
