#-------------------------------------------------------------------------
# [SECTION] STB libraries implementation
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Style functions
#-----------------------------------------------------------------------------

def style_colors_dark(GuiStyle dst = None):
    """Set the style to Dark.

       new, recommended style (default)

    .. wraps::
        void StyleColorsDark(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsDark(dst._ptr)
    else:
        cimgui.StyleColorsDark(NULL)

def style_colors_classic(GuiStyle dst = None):
    """Set the style to Classic.

       classic imgui style.

    .. wraps::
        void StyleColorsClassic(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsClassic(dst._ptr)
    else:
        cimgui.StyleColorsClassic(NULL)

def style_colors_light(GuiStyle dst = None):
    """Set the style to Light.

       best used with borders and a custom, thicker font

    .. wraps::
        void StyleColorsLight(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsLight(dst._ptr)
    else:
        cimgui.StyleColorsLight(NULL)

#-----------------------------------------------------------------------------
# [SECTION] ImDrawList
#-----------------------------------------------------------------------------

cdef class _DrawCmd(object):
    cdef cimgui.ImDrawCmd* _ptr

    # todo: consider using fast instantiation here
    #       see: http://cython.readthedocs.io/en/latest/src/userguide/extension_types.html#fast-instantiation
    @staticmethod
    cdef from_ptr(cimgui.ImDrawCmd* ptr):
        if ptr == NULL:
            return None

        instance = _DrawCmd()
        instance._ptr = ptr
        return instance

    @property
    def texture_id(self):
        return <object>self._ptr.TextureId

    @property
    def clip_rect(self):
        return _cast_ImVec4_tuple(self._ptr.ClipRect)

    @property
    def elem_count(self):
        return self._ptr.ElemCount


cdef class _DrawList(object):
    """ Low level drawing API.

    _DrawList instance can be acquired by calling :func:`get_window_draw_list`.
    """
    cdef cimgui.ImDrawList* _ptr

    @staticmethod
    cdef from_ptr(cimgui.ImDrawList* ptr):
        if ptr == NULL:
            return None

        instance = _DrawList()
        instance._ptr = ptr
        return instance

    @property
    def cmd_buffer_size(self):
        return self._ptr.CmdBuffer.Size

    @property
    def cmd_buffer_data(self):
        return <uintptr_t>self._ptr.CmdBuffer.Data

    @property
    def vtx_buffer_size(self):
        return self._ptr.VtxBuffer.Size

    @property
    def vtx_buffer_data(self):
        return <uintptr_t>self._ptr.VtxBuffer.Data

    @property
    def idx_buffer_size(self):
        return self._ptr.IdxBuffer.Size

    @property
    def idx_buffer_data(self):
        return <uintptr_t>self._ptr.IdxBuffer.Data
    
    @property
    def flags(self):
        return self._ptr.Flags
        
    @flags.setter
    def flags(self, cimgui.ImDrawListFlags flags):
        self._ptr.Flags = flags
    
    def push_clip_rect(
        self,
        float clip_rect_min_x, float clip_rect_min_y,
        float clip_rect_max_x, float clip_rect_max_y,
        bool intersect_with_current_clip_rect = False
        ):
        """Render-level scissoring. This is passed down to your render function 
        but not used for CPU-side coarse clipping. Prefer using higher-level :func:`push_clip_rect()` 
        to affect logic (hit-testing and widget culling)
        
        .. wraps::
            void PushClipRect(ImVec2 clip_rect_min, ImVec2 clip_rect_max, bool intersect_with_current_clip_rect = false)
        """
        self._ptr.PushClipRect(
            _cast_args_ImVec2(clip_rect_min_x, clip_rect_min_y),
            _cast_args_ImVec2(clip_rect_max_x, clip_rect_max_y),
            intersect_with_current_clip_rect
        )
    
    def push_clip_rect_full_screen(self):
        """
        .. wraps::
            void PushClipRectFullScreen()
        """
        self._ptr.PushClipRectFullScreen()
    
    def pop_clip_rect(self):
        """Render-level scisoring. 
        
        .. wraps::
            void PopClipRect()
        """
        self._ptr.PopClipRect()
    
    def push_texture_id(self, texture_id):
        """
        .. wraps::
            void PushTextureID(ImTextureID texture_id)
        """
        get_current_context()._keepalive_cache.append(texture_id)
        self._ptr.PushTextureID(<void*>texture_id)
    
    
    def pop_texture_id(self):
        """
        .. wraps::
            void PopTextureID()
        """
        self._ptr.PopTextureID()
    
    def get_clip_rect_min(self):
        """
        .. wraps::
            ImVec2 GetClipRectMin()
        """
        return _cast_ImVec2_tuple(self._ptr.GetClipRectMin())
    
    def get_clip_rect_max(self):
        """
        .. wraps::
            ImVec2 GetClipRectMax()
        """
        return _cast_ImVec2_tuple(self._ptr.GetClipRectMax())
    
    def add_line(
            self,
            float start_x, float start_y,
            float end_x, float end_y,
            cimgui.ImU32 col,
            # note: optional
            float thickness=1.0,
        ):
        """Add a straight line to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Line example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_line(20, 35, 180, 80, imgui.get_color_u32_rgba(1,1,0,1), 3)
            draw_list.add_line(180, 35, 20, 80, imgui.get_color_u32_rgba(1,0,0,1), 3)
            imgui.end()

        Args:
            start_x (float): X coordinate of first point
            start_y (float): Y coordinate of first point
            end_x (float): X coordinate of second point
            end_y (float): Y coordinate of second point
            col (ImU32): RGBA color specification
            thickness (float): Line thickness in pixels

        .. wraps::
            void ImDrawList::AddLine(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col,
                float thickness = 1.0f
            )
        """
        self._ptr.AddLine(
            _cast_args_ImVec2(start_x, start_y),
            _cast_args_ImVec2(end_x, end_y),
            col,
            thickness,
        )

    def add_rect(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col,
            # note: optional
            float rounding = 0.0,
            cimgui.ImDrawFlags flags = 0,
            float thickness = 1.0,
        ):
        """Add a rectangle outline to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Rect example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_rect(20, 35, 90, 80, imgui.get_color_u32_rgba(1,1,0,1), thickness=3)
            draw_list.add_rect(110, 35, 180, 80, imgui.get_color_u32_rgba(1,0,0,1), rounding=5, thickness=3)
            imgui.end()

        Args:
            upper_left_x (float): X coordinate of top-left corner
            upper_left_y (float): Y coordinate of top-left corner
            lower_right_x (float): X coordinate of lower-right corner
            lower_right_y (float): Y coordinate of lower-right corner
            col (ImU32): RGBA color specification
            rounding (float): Degree of rounding, defaults to 0.0
            flags (ImDrawFlags): Draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.
            thickness (float): Line thickness, defaults to 1.0

        .. wraps::
            void ImDrawList::AddRect(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col,
                float rounding = 0.0f,
                ImDrawFlags flags = 0,
                float thickness = 1.0f
            )
        """
        self._ptr.AddRect(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col,
            rounding,
            flags,
            thickness,
        )

    def add_rect_filled(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col,
            # note: optional
            float rounding = 0.0,
            cimgui.ImDrawFlags flags = 0,
        ):
        """Add a filled rectangle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Filled rect example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_rect_filled(20, 35, 90, 80, imgui.get_color_u32_rgba(1,1,0,1))
            draw_list.add_rect_filled(110, 35, 180, 80, imgui.get_color_u32_rgba(1,0,0,1), 5)
            imgui.end()

        Args:
            upper_left_x (float): X coordinate of top-left corner
            upper_left_y (float): Y coordinate of top-left corner
            lower_right_x (float): X coordinate of lower-right corner
            lower_right_y (float): Y coordinate of lower-right corner
            col (ImU32): RGBA color specification
            rounding (float): Degree of rounding, defaults to 0.0
            flags (ImDrawFlags): Draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.

        .. wraps::
            void ImDrawList::AddRectFilled(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col,
                float rounding = 0.0f,
                ImDrawFlags flags = 0
            )
        """
        self._ptr.AddRectFilled(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col,
            rounding,
            flags
        )

    def add_rect_filled_multicolor(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col_upr_left,
            cimgui.ImU32 col_upr_right,
            cimgui.ImU32 col_bot_right,
            cimgui.ImU32 col_bot_left
        ):
        """Add a multicolor filled rectangle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Multicolored filled rect example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_rect_filled_multicolor(20, 35, 190, 80, imgui.get_color_u32_rgba(1,0,0,1),
                imgui.get_color_u32_rgba(0,1,0,1), imgui.get_color_u32_rgba(0,0,1,1),
                imgui.get_color_u32_rgba(1,1,1,1))
            imgui.end()

        Args:
            upper_left_x (float): X coordinate of top-left corner
            upper_left_y (float): Y coordinate of top-left corner
            lower_right_x (float): X coordinate of lower-right corner
            lower_right_y (float): Y coordinate of lower-right corner
            col_upr_left (ImU32): RGBA color for the top left corner
            col_upr_right (ImU32): RGBA color for the top right corner
            col_bot_right (ImU32): RGBA color for the bottom right corner
            col_bot_left (ImU32): RGBA color for the bottom left corner

        .. wraps::
            void ImDrawList::AddRectFilledMultiColor(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col_upr_left,
                ImU32 col_upr_right,
                ImU32 col_bot_right,
                ImU32 col_bot_left
            )
        """
        self._ptr.AddRectFilledMultiColor(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col_upr_left,
            col_upr_right,
            col_bot_right,
            col_bot_left
        )

    def add_quad(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            float point4_x, float point4_y,
            cimgui.ImU32 col,
            # note: optional
            float thickness = 1.0
        ):
        """Add a quad to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Quad example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_quad(20, 35, 85, 30, 90, 80, 17, 76, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_quad(110, 35, 177, 33, 180, 80, 112, 79, imgui.get_color_u32_rgba(1,0,0,1), 5)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                point4_x (float): X coordinate of fourth corner
                point4_y (float): Y coordinate of fourth corner
                col (ImU32): RGBA color specification
                thickness (float): Line thickness

            .. wraps::
                void ImDrawList::AddQuad(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    const ImVec2& p4,
                    ImU32 col,
                    float thickness = 1.0
                )
        """
        self._ptr.AddQuad(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            _cast_args_ImVec2(point4_x, point4_y),
            col,
            thickness
        )

    def add_quad_filled(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            float point4_x, float point4_y,
            cimgui.ImU32 col,
        ):
        """Add a filled quad to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Filled Quad example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_quad_filled(20, 35, 85, 30, 90, 80, 17, 76, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_quad_filled(110, 35, 177, 33, 180, 80, 112, 79, imgui.get_color_u32_rgba(1,0,0,1))
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                point4_x (float): X coordinate of fourth corner
                point4_y (float): Y coordinate of fourth corner
                col (ImU32): RGBA color specification

            .. wraps::
                void ImDrawList::AddQuadFilled(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    const ImVec2& p4,
                    ImU32 col
                )
        """
        self._ptr.AddQuadFilled(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            _cast_args_ImVec2(point4_x, point4_y),
            col
        )

    def add_triangle(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            cimgui.ImU32 col,
            # note: optional
            float thickness = 1.0
        ):
        """Add a triangle to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Triangle example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_triangle(20, 35, 90, 35, 55, 80, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_triangle(110, 35, 180, 35, 145, 80, imgui.get_color_u32_rgba(1,0,0,1), 5)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                col (ImU32): RGBA color specification
                thickness (float): Line thickness

            .. wraps::
                void ImDrawList::AddTriangle(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    ImU32 col,
                    float thickness = 1.0
                )
        """
        self._ptr.AddTriangle(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            col,
            thickness
        )

    def add_triangle_filled(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            cimgui.ImU32 col,
        ):
        """Add a filled triangle to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Filled triangle example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_triangle_filled(20, 35, 90, 35, 55, 80, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_triangle_filled(110, 35, 180, 35, 145, 80, imgui.get_color_u32_rgba(1,0,0,1))
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                col (ImU32): RGBA color specification

            .. wraps::
                void ImDrawList::AddTriangleFilled(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    ImU32 col
                )
        """
        self._ptr.AddTriangleFilled(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            col
        )

    def add_bezier_cubic(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            float point4_x, float point4_y,
            cimgui.ImU32 col,
            float thickness,
            # note: optional
            int num_segments = 0
        ):
        """Add a cubic bezier curve to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Cubic bezier example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_bezier_cubic(20, 35, 90, 80, 110, 180, 145, 35, imgui.get_color_u32_rgba(1,1,0,1), 2)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first point
                point1_y (float): Y coordinate of first point
                point2_x (float): X coordinate of second point
                point2_y (float): Y coordinate of second point
                point3_x (float): X coordinate of third point
                point3_y (float): Y coordinate of third point
                point4_x (float): X coordinate of fourth point
                point4_y (float): Y coordinate of fourth point
                col (ImU32): RGBA color specification
                thickness (float): Line thickness
                num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

            .. wraps::
                void ImDrawList::AddBezierCubic(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    const ImVec2& p4,
                    ImU32 col,
                    float thickness,
                    int num_segments = 0
                )
        """
        self._ptr.AddBezierCubic(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            _cast_args_ImVec2(point4_x, point4_y),
            col,
            thickness,
            num_segments
        )

    def add_bezier_quadratic(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            cimgui.ImU32 col,
            float thickness,
            # note: optional
            int num_segments = 0
        ):
        """Add a quadratic bezier curve to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Quadratic bezier example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_bezier_quadratic(20, 35, 90, 80, 145, 35, imgui.get_color_u32_rgba(1,1,0,1), 2)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first point
                point1_y (float): Y coordinate of first point
                point2_x (float): X coordinate of second point
                point2_y (float): Y coordinate of second point
                point3_x (float): X coordinate of third point
                point3_y (float): Y coordinate of third point
                col (ImU32): RGBA color specification
                thickness (float): Line thickness
                num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

            .. wraps::
                void ImDrawList::AddBezierCubic(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    ImU32 col,
                    float thickness,
                    int num_segments = 0
                )
        """
        self._ptr.AddBezierQuadratic(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            col,
            thickness,
            num_segments
        )

    def add_circle(
            self,
            float centre_x, float centre_y,
            float radius,
            cimgui.ImU32 col,
            # note: optional
            int num_segments = 0,
            float thickness = 1.0
        ):
        """Add a circle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Circle example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_circle(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1), thickness=3)
            imgui.end()

        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): circle radius
            col (ImU32): RGBA color specification
            num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation
            thickness (float): Line thickness

        .. wraps::
            void ImDrawList::AddCircle(
                const ImVec2& centre,
                float radius,
                ImU32 col,
                int num_segments = 0,
                float thickness = 1.0
            )
        """
        self._ptr.AddCircle(
            _cast_args_ImVec2(centre_x, centre_y),
            radius,
            col,
            num_segments,
            thickness
        )

    def add_circle_filled(
            self,
            float centre_x, float centre_y,
            float radius,
            cimgui.ImU32 col,
            # note: optional
            cimgui.ImU32 num_segments = 0
        ):

        """Add a filled circle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Filled circle example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_circle_filled(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1))
            imgui.end()

        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): circle radius
            col (ImU32): RGBA color specification
            num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

        .. wraps::
            void ImDrawList::AddCircleFilled(
                const ImVec2& centre,
                float radius,
                ImU32 col,
                int num_segments = 0
            )
        """
        self._ptr.AddCircleFilled(
            _cast_args_ImVec2(centre_x, centre_y),
            radius,
            col,
            num_segments
        )
    
    def add_ngon(
        self,
        float centre_x, float centre_y,
        float radius, 
        cimgui.ImU32 col, 
        int num_segments, 
        float thickness = 1.0
    ):
        """Draw a regular Ngon
        
        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): Distance of points to center
            col (ImU32): RGBA color specification
            num_segments (int): Number of segments
            thickness (float): Line thickness

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Ngon Example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_ngon(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1), 5)
            imgui.end()
        
        .. wraps::
            void  AddNgon(
                const ImVec2& center, 
                float radius, 
                ImU32 col, 
                int num_segments, 
                float thickness = 1.0f
            )
        """
        self._ptr.AddNgon(
            _cast_args_ImVec2(centre_x, centre_y),
            radius, col, num_segments, thickness
        )
    
    def add_ngon_filled(
        self,
        float centre_x, float centre_y,
        float radius, 
        cimgui.ImU32 col, 
        int num_segments
    ):
        """Draw a regular Ngon
        
        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): Distance of points to center
            col (ImU32): RGBA color specification
            num_segments (int): Number of segments

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Filled Ngon Example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_ngon_filled(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1), 5)
            imgui.end()
        
        .. wraps::
            void  AddNgonFilled(
                const ImVec2& center, 
                float radius, 
                ImU32 col, 
                int num_segments
            )
        """
        self._ptr.AddNgonFilled(
            _cast_args_ImVec2(centre_x, centre_y),
            radius, col, num_segments
        )
    
    def add_text(
            self,
            float pos_x, float pos_y,
            cimgui.ImU32 col,
            str text
        ):
        """Add text to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Text example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_text(20, 35, imgui.get_color_u32_rgba(1,1,0,1), "Hello!")
            imgui.end()

        Args:
            pos_x (float): X coordinate of the text's upper-left corner
            pos_y (float): Y coordinate of the text's upper-left corner
            col (ImU32): RGBA color specification
            text (str): text

        .. wraps::
            void ImDrawList::AddText(
                const ImVec2& pos,
                ImU32 col,
                const char* text_begin,
                const char* text_end = NULL
            )
        """
        self._ptr.AddText(
            _cast_args_ImVec2(pos_x, pos_y),
            col,
            _bytes(text),
            NULL
        )

    def add_image(self,
        texture_id,
        tuple a,
        tuple b,
        tuple uv_a=(0,0),
        tuple uv_b=(1,1),
        cimgui.ImU32 col=0xffffffff):
        """Add image to the draw list. Aspect ratio is not preserved.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Image example")
            texture_id = imgui.get_io().fonts.texture_id
            draw_list = imgui.get_window_draw_list()
            draw_list.add_image(texture_id, (20, 35), (180, 80), col=imgui.get_color_u32_rgba(0.5,0.5,1,1))
            imgui.end()

        Args:
            texture_id (object): ID of the texture to draw
            a (tuple): top-left image corner coordinates,
            b (tuple): bottom-right image corner coordinates,
            uv_a (tuple): UV coordinates of the top-left corner, defaults to (0, 0)
            uv_b (tuple): UV coordinates of the bottom-right corner, defaults to (1, 1)
            col (ImU32): tint color, defaults to 0xffffffff (no tint)

        .. wraps::
            void ImDrawList::AddImage(
                ImTextureID user_texture_id,
                const ImVec2& a,
                const ImVec2& b,
                const ImVec2& uv_a = ImVec2(0,0),
                const ImVec2& uv_b = ImVec2(1,1),
                ImU32 col = 0xFFFFFFFF
            )
        """
        get_current_context()._keepalive_cache.append(texture_id)
        self._ptr.AddImage(
            <void*>texture_id,
            _cast_tuple_ImVec2(a),
            _cast_tuple_ImVec2(b),
            _cast_tuple_ImVec2(uv_a),
            _cast_tuple_ImVec2(uv_b),
            col
        )

    def add_image_rounded(self,
        texture_id,
        tuple a,
        tuple b,
        tuple uv_a=(0,0),
        tuple uv_b=(1,1),
        cimgui.ImU32 col=0xffffffff,
        float rounding = 0.0,
        cimgui.ImDrawFlags flags = 0):
        """Add rounded image to the draw list. Aspect ratio is not preserved.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Image example")
            texture_id = imgui.get_io().fonts.texture_id
            draw_list = imgui.get_window_draw_list()
            draw_list.add_image_rounded(texture_id, (20, 35), (180, 80), col=imgui.get_color_u32_rgba(0.5,0.5,1,1), rounding=10)
            imgui.end()

        Args:
            texture_id (object): ID of the texture to draw
            a (tuple): top-left image corner coordinates,
            b (tuple): bottom-right image corner coordinates,
            uv_a (tuple): UV coordinates of the top-left corner, defaults to (0, 0)
            uv_b (tuple): UV coordinates of the bottom-right corner, defaults to (1, 1)
            col (ImU32): tint color, defaults to 0xffffffff (no tint)
            rounding (float): degree of rounding, defaults to 0.0
            flags (ImDrawFlags): draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.

        .. wraps::
            void ImDrawList::AddImageRounded(
                ImTextureID user_texture_id,
                const ImVec2& a,
                const ImVec2& b,
                const ImVec2& uv_a = ImVec2(0,0),
                const ImVec2& uv_b = ImVec2(1,1),
                ImU32 col = 0xFFFFFFFF,
                float rounding = 0.0f,
                ImDrawFlags flags = 0
            )
        """
        get_current_context()._keepalive_cache.append(texture_id)
        self._ptr.AddImageRounded(
            <void*>texture_id,
            _cast_tuple_ImVec2(a),
            _cast_tuple_ImVec2(b),
            _cast_tuple_ImVec2(uv_a),
            _cast_tuple_ImVec2(uv_b),
            col,
            rounding,
            flags
        )

    def add_polyline(
            self,
            list points,
            cimgui.ImU32 col,
            cimgui.ImDrawFlags flags = 0,
            float thickness=1.0
        ):
        """Add a optionally closed polyline to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Polyline example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_polyline([(20, 35), (90, 35), (55, 80)], imgui.get_color_u32_rgba(1,1,0,1), flags=imgui.DRAW_NONE, thickness=3)
            draw_list.add_polyline([(110, 35), (180, 35), (145, 80)], imgui.get_color_u32_rgba(1,0,0,1), flags=imgui.DRAW_CLOSED, thickness=3)
            imgui.end()

        Args:
            points (list): list of points
            col (float): RGBA color specification
            flags (ImDrawFlags): Drawing flags. See:
                :ref:`list of available flags <draw-flag-options>`.
            thickness (float): line thickness

        .. wraps::
            void ImDrawList::AddPolyline(
                const ImVec2* points,
                int num_points,
                ImU32 col,
                flags flags,
                float thickness
            )
        """
        num_points = len(points)
        cdef cimgui.ImVec2 *pts
        pts = <cimgui.ImVec2 *>malloc(num_points * cython.sizeof(cimgui.ImVec2))
        for i in range(num_points):
            pts[i] = _cast_args_ImVec2(points[i][0], points[i][1])
        self._ptr.AddPolyline(
            pts,
            num_points,
            col,
            flags,
            thickness
        )
        free(pts)

    # Path related functions

    def path_clear(self):
        """
        Clear the current list of path point

        .. wraps::
            void ImDrawList::PathClear()
        """
        self._ptr.PathClear()

    def path_line_to(self, float x, float y):
        """
        Add a point to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path line to example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_line_to(20, 35)
            draw_list.path_line_to(180, 80)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_line_to(180, 35)
            draw_list.path_line_to(20, 80)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,0,0,1), flags=0, thickness=3)
            imgui.end()

        Args:
            x (float): path point x coordinate
            y (float): path point y coordinate

        .. wraps::
            void ImDrawList::PathLineTo(
                const ImVec2& pos,
            )
        """
        self._ptr.PathLineTo(
            _cast_args_ImVec2(x, y)
        )

    def path_arc_to(
            self,
            float center_x, float center_y,
            float radius,
            float a_min, float a_max,
            # note: optional
            cimgui.ImU32 num_segments = 0
        ):
        """
        Add an arc to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path arc to example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_arc_to(55, 60, 30, 1, 5)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_arc_to(155, 60, 30, -2, 2)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,0,0,1))
            imgui.end()

        Args:
            center_x (float): arc center x coordinate
            center_y (float): arc center y coordinate
            radius (flaot): radius of the arc
            a_min (float): minimum angle of the arc (in radian)
            a_max (float): maximum angle of the arc (in radian)
            num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

        .. wraps::
            void ImDrawList::PathArcTo(
                const ImVec2& center,
                float radius,
                float a_min,
                float a_max,
                int num_segments = 0
            )
        """
        self._ptr.PathArcTo(
            _cast_args_ImVec2(center_x, center_y),
            radius,
            a_min, a_max,
            num_segments
        )

    def path_arc_to_fast(
            self,
            float center_x, float center_y,
            float radius,
            cimgui.ImU32 a_min_of_12,
            cimgui.ImU32 a_max_of_12,
        ):
        """
        Add an arc to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path arc to fast example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_arc_to_fast(55, 60, 30, 0, 6)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_arc_to_fast(155, 60, 30, 3, 9)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,0,0,1))
            imgui.end()

        Args:
            center_x (float): arc center x coordinate
            center_y (float): arc center y coordinate
            radius (flaot): radius of the arc
            a_min_of_12 (ImU32): minimum angle of the arc
            a_max_of_12 (ImU32): maximum angle of the arc

        .. wraps::
            void ImDrawList::PathArcToFast(
                const ImVec2& center,
                float radius,
                int a_min_of_12,
                int a_max_of_12
            )
        """
        self._ptr.PathArcToFast(
            _cast_args_ImVec2(center_x, center_y),
            radius,
            a_min_of_12,
            a_max_of_12,
        )

    def path_rect(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            # note: optional
            float rounding = 0.0,
            cimgui.ImDrawFlags flags = 0
        ):
        """
        Add a rect to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path arc to fast example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_rect(20, 35, 90, 80)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_rect(110, 35, 180, 80, 5)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,0,0,1))
            imgui.end()

        Args:
            point1_x (float): point1 x coordinate
            point1_y (float): point1 y coordinate
            point2_x (float): point2 x coordinate
            point2_y (float): point2 y coordinate
            rounding (flaot): Degree of rounding, defaults to 0.0
            flags (ImDrawFlags):Draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.

        .. wraps::
            void ImDrawList::PathRect(
                const ImVec2& p1,
                const ImVec2& p2,
                float rounding = 0.0,
                ImDrawFlags flags = 0
            )
        """
        self._ptr.PathRect(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            rounding,
            flags
        )

    # Path rendering functions

    def path_fill_convex(self, cimgui.ImU32 col):
        """

        Note: Filled shapes must always use clockwise winding order.
        The anti-aliasing fringe depends on it. Counter-clockwise shapes
        will have "inward" anti-aliasing.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path fill convex example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_line_to(100, 60)
            draw_list.path_arc_to(100, 60, 30, 0.5, 5.5)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,1,0,1))
            imgui.end()

        Args:
            col (ImU32): color to fill the path shape with

        .. wraps::
            void ImDrawList::PathFillConvex(
                ImU32   col
            );
        """
        self._ptr.PathFillConvex(col)

    def path_stroke(
            self,
            cimgui.ImU32 col,
            # note: optional
            cimgui.ImDrawFlags flags = 0,
            float thickness = 1.0
        ):
        """
        Args:
            col (ImU32): color to fill the path shape with
            flags (ImDrawFlags): draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.
            thickness (float): Line thickness in pixels

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path stroke example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_line_to(100, 60)
            draw_list.path_arc_to(100, 60, 30, 0.5, 5.5)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=imgui.DRAW_CLOSED, thickness=3)
            imgui.end()


        .. wraps::
            void ImDrawList::PathStroke(
                ImU32 col,
                ImDrawFlags flags = 0,
                float thickness = 1.0
            );
        """
        self._ptr.PathStroke(
            col,
            flags,
            thickness
        )

    # channels

    def channels_split(self, int channels_count):
        """Use to split render into layers. 
        By switching channels to can render out-of-order (e.g. submit FG primitives before BG primitives)
        Use to minimize draw calls (e.g. if going back-and-forth between multiple clipping rectangles, prefer to append into separate channels then merge at the end)
        
        Prefer using your own persistent instance of ImDrawListSplitter as you can stack them.
        Using the ImDrawList::ChannelsXXXX you cannot stack a split over another.
        
        Warning - be careful with using channels as "layers".
        Child windows are always drawn after their parent, so they will
        paint over its channels.
        To paint over child windows, use `OverlayDrawList`.
        """
        # TODO: document
        self._ptr.ChannelsSplit(channels_count)

    def channels_set_current(self, int idx):
        # TODO: document
        self._ptr.ChannelsSetCurrent(idx)

    def channels_merge(self):
        # TODO: document
        self._ptr.ChannelsMerge()
        
    def prim_reserve(self, int idx_count, int vtx_count):
        """Reserve space for a number of vertices and indices.
        You must finish filling your reserved data before calling `prim_reserve()` again, as it may 
        reallocate or submit the intermediate results. `prim_unreserve()` can be used to release 
        unused allocations.
        
        Drawing a quad is 6 idx (2 triangles) with 2 sharing vertices for a total of 4 vertices.
        
        Args:
            idx_count (int): Number of indices to add to IdxBuffer
            vtx_count (int): Number of verticies to add to VtxBuffer
        
        .. wraps::
            void PrimReserve(int idx_count, int vtx_count)
        """
        self._ptr.PrimReserve(idx_count, vtx_count)
    
    def prim_unreserve(self, int idx_count, int vtx_count):
        """Release the a number of reserved vertices/indices from the end of the 
        last reservation made with `prim_reserve()`.
        
        Args:
            idx_count (int): Number of indices to remove from IdxBuffer
            vtx_count (int): Number of verticies to remove from VtxBuffer
        
        .. wraps::
            void PrimUnreserve(int idx_count, int vtx_count)
        """
        self._ptr.PrimUnreserve(idx_count, vtx_count)
    
    def prim_rect(self, float a_x, float a_y, float b_x, float b_y, cimgui.ImU32 color = 0xFFFFFFFF):
        """Axis aligned rectangle (2 triangles)
        Reserve primitive space with `prim_rect()` before calling `prim_quad_UV()`.
        Each call to `prim_rect()` is 6 idx and 4 vtx.
        
        Args:
            a_x, a_y (float): First rectangle point coordinates
            b_x, b_y (float): Opposite rectangle point coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimRect(const ImVec2& a, const ImVec2& b, ImU32 col)
        """
        self._ptr.PrimRect(
            _cast_args_ImVec2(a_x, a_y),
            _cast_args_ImVec2(b_x, b_y),
            color
        )
    
    def prim_rect_UV(
        self, 
        float a_x, float a_y, 
        float b_x, float b_y,
        float uv_a_u, float uv_a_v,
        float uv_b_u, float uv_b_v,
        cimgui.ImU32 color = 0xFFFFFFFF
        ):
        """Axis aligned rectangle (2 triangles) with custom UV coordinates.
        Reserve primitive space with `prim_reserve()` before calling `prim_rect_UV()`.
        Each call to `prim_rect_UV()` is 6 idx and 4 vtx.
        Set the texture ID using `push_texture_id()`.
        
        Args:
            a_x, a_y (float): First rectangle point coordinates
            b_x, b_y (float): Opposite rectangle point coordinates
            uv_a_u, uv_a_v (float): First rectangle point UV coordinates
            uv_b_u, uv_b_v (float): Opposite rectangle point UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimRectUV(const ImVec2& a, const ImVec2& b, const ImVec2& uv_a, const ImVec2& uv_b, ImU32 col)
        """
        self._ptr.PrimRectUV(
            _cast_args_ImVec2(a_x, a_y),
            _cast_args_ImVec2(b_x, b_y),
            _cast_args_ImVec2(uv_a_u, uv_a_v),
            _cast_args_ImVec2(uv_b_u, uv_b_v),
            color
        )
    
    def prim_quad_UV(
        self, 
        float a_x, float a_y, 
        float b_x, float b_y, 
        float c_x, float c_y, 
        float d_x, float d_y,
        float uv_a_u, float uv_a_v,
        float uv_b_u, float uv_b_v,
        float uv_c_u, float uv_c_v,
        float uv_d_u, float uv_d_v,
        cimgui.ImU32 color = 0xFFFFFFFF
        ):
        """Custom quad (2 triangles) with custom UV coordinates.
        Reserve primitive space with `prim_reserve()` before calling `prim_quad_UV()`.
        Each call to `prim_quad_UV()` is 6 idx and 4 vtx.
        Set the texture ID using `push_texture_id()`.
        
        Args:
            a_x, a_y (float): Point 1 coordinates
            b_x, b_y (float): Point 2 coordinates
            c_x, c_y (float): Point 3 coordinates
            d_x, d_y (float): Point 4 coordinates
            uv_a_u, uv_a_v (float): Point 1 UV coordinates
            uv_b_u, uv_b_v (float): Point 2 UV coordinates
            uv_c_u, uv_c_v (float): Point 3 UV coordinates
            uv_d_u, uv_d_v (float): Point 4 UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimQuadUV(const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, const ImVec2& uv_a, const ImVec2& uv_b, const ImVec2& uv_c, const ImVec2& uv_d, ImU32 col)
        """
        self._ptr.PrimQuadUV(
            _cast_args_ImVec2(a_x, a_y),
            _cast_args_ImVec2(b_x, b_y),
            _cast_args_ImVec2(c_x, c_y),
            _cast_args_ImVec2(d_x, d_y),
            _cast_args_ImVec2(uv_a_u, uv_a_v),
            _cast_args_ImVec2(uv_b_u, uv_b_v),
            _cast_args_ImVec2(uv_c_u, uv_c_v),
            _cast_args_ImVec2(uv_d_u, uv_d_v),
            color
        )
    
    def prim_write_vtx(self, float pos_x, float pos_y, float u, float v, cimgui.ImU32 color = 0xFFFFFFFF):
        """Write a vertex
        
        Args:
            pos_x, pos_y (float): Point coordinates
            u, v (float): Point UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void  PrimWriteVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col)
        """
        self._ptr.PrimWriteVtx(
            _cast_args_ImVec2(pos_x, pos_y),
            _cast_args_ImVec2(u, v),
            color
        )
    
    def prim_write_idx(self, cimgui.ImDrawIdx idx):
        """Write index
        
        Args:
            idx (ImDrawIdx): index to write
        
        .. wraps::
            void  PrimWriteIdx(ImDrawIdx idx)
        """
        self._ptr.PrimWriteIdx(idx)
    
    def prim_vtx(self, float pos_x, float pos_y, float u, float v, cimgui.ImU32 color = 0xFFFFFFFF):
        """Write vertex with unique index
        
        Args:
            pos_x, pos_y (float): Point coordinates
            u, v (float): Point UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col)
        """
        self._ptr.PrimVtx(
            _cast_args_ImVec2(pos_x, pos_y),
            _cast_args_ImVec2(u,v),
            color
        )
    
    @property
    def commands(self):
        return [
            # todo: consider operator overloading in pxd file
            _DrawCmd.from_ptr(&self._ptr.CmdBuffer.Data[idx])
            # perf: short-wiring instead of using property
            # note: add py3k compat
            for idx in xrange(self._ptr.CmdBuffer.Size)
        ]


#-----------------------------------------------------------------------------
# [SECTION] ImDrawListSplitter
#-----------------------------------------------------------------------------
# FIXME: This may be a little confusing, trying to be a little too low-level/optimal instead of just doing vector swap..
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] ImDrawData
#-----------------------------------------------------------------------------

cdef class _DrawData(object):
    cdef cimgui.ImDrawData* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImDrawData* ptr):
        if ptr == NULL:
            return None

        instance = _DrawData()
        instance._ptr = ptr
        return instance

    def deindex_all_buffers(self):
        self._require_pointer()
        self._ptr.DeIndexAllBuffers()

    def scale_clip_rects(self, width, height):
        self._require_pointer()
        self._ptr.ScaleClipRects(_cast_args_ImVec2(width, height))

    @property
    def valid(self):
        self._require_pointer()
        return self._ptr.Valid

    @property
    def cmd_count(self):
        self._require_pointer()
        return self._ptr.CmdListsCount

    @property
    def total_vtx_count(self):
        self._require_pointer()
        return self._ptr.TotalVtxCount
        
    @property
    def display_pos(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.DisplayPos)
        
    @property
    def display_size(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.DisplaySize)
        
    @property
    def frame_buffer_scale(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.FramebufferScale)

    @property
    def total_idx_count(self):
        self._require_pointer()
        return self._ptr.TotalIdxCount

    @property
    def commands_lists(self):
        return [
            _DrawList.from_ptr(self._ptr.CmdLists[idx])
            # perf: short-wiring instead of using property
            for idx in xrange(self._ptr.CmdListsCount)
        ]

    @property
    def owner_viewport(self):
        self._require_pointer()
        return _ImGuiViewport.from_ptr(self._ptr.OwnerViewport)

#-----------------------------------------------------------------------------
# [SECTION] Helpers ShadeVertsXXX functions
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] ImFontConfig
#-----------------------------------------------------------------------------

cdef class FontConfig(object):
    cdef cimgui.ImFontConfig config

    def __init__(
        self,
        font_no=None,
        size_pixels=None,
        oversample_h=None,
        oversample_v=None,
        pixel_snap_h=None,
        glyph_extra_spacing_x=None,
        glyph_extra_spacing_y=None,
        glyph_offset_x=None,
        glyph_offset_y=None,
        glyph_min_advance_x=None,
        glyph_max_advance_x=None,
        merge_mode=None,
        font_builder_flags=None,
        rasterizer_multiply=None,
        ellipsis_char=None
        ):
        if font_no is not None:
            self.config.FontNo = font_no
        if size_pixels is not None:
            self.config.SizePixels = size_pixels
        if oversample_h is not None:
            self.config.OversampleH = oversample_h
        if oversample_v is not None:
            self.config.OversampleV = oversample_v
        if pixel_snap_h is not None:
            self.config.PixelSnapH = pixel_snap_h
        if glyph_extra_spacing_x is not None:
            self.config.GlyphExtraSpacing.x = glyph_extra_spacing_x
        if glyph_extra_spacing_y is not None:
            self.config.GlyphExtraSpacing.y = glyph_extra_spacing_y
        if glyph_offset_x is not None:
            self.config.GlyphOffset.x = glyph_offset_x
        if glyph_offset_y is not None:
            self.config.GlyphOffset.y = glyph_offset_y
        if glyph_min_advance_x is not None:
            self.config.GlyphMinAdvanceX = glyph_min_advance_x
        if glyph_max_advance_x is not None:
            self.config.GlyphMaxAdvanceX = glyph_max_advance_x
        if merge_mode is not None:
            self.config.MergeMode = merge_mode
        #if font_builder_flags is not None:
        #    self.config.FontBuilderFlags = font_builder_flags
        if rasterizer_multiply is not None:
            self.config.RasterizerMultiply = rasterizer_multiply
        if ellipsis_char is not None:
            self.config.EllipsisChar = ellipsis_char

#-----------------------------------------------------------------------------
# [SECTION] ImFontAtlas
#-----------------------------------------------------------------------------

cdef class _StaticGlyphRanges(object):
    cdef const cimgui.ImWchar* ranges_ptr

    @staticmethod
    cdef from_ptr(const cimgui.ImWchar* ptr):
        if ptr == NULL:
            return None

        instance = _StaticGlyphRanges()
        instance.ranges_ptr = ptr
        return instance

cdef class GlyphRanges(object):
    cdef const cimgui.ImWchar* ranges_ptr

    def __init__(self, glyph_ranges):
        self.ranges_ptr = NULL
        range_list = list(glyph_ranges)
        if len(range_list) % 2 != 1 or range_list[-1] != 0:
            raise RuntimeError('glyph_ranges must be pairs of integers (inclusive range) followed by a zero')
        arr = <cimgui.ImWchar*>malloc(sizeof(cimgui.ImWchar) * len(range_list))
        self.ranges_ptr = arr
        for i, value in enumerate(range_list):
            i_value = int(value)
            if i_value < 0:
                raise RuntimeError('glyph_ranges cannot contain negative values')
            arr[i] = i_value

    def __del__(self):
        free(<void*>self.ranges_ptr)
        self.ranges_ptr = NULL

cdef class _FontAtlas(object):
    """Font atlas object responsible for controling and loading fonts.

    This class is not intended to be instantiated by user (thus `_`
    name prefix). It should be accessed through :any:`_IO.fonts` attribute
    of :class:`_IO` obtained with :func:`get_io` function.

    Example::

        import imgui

        io = imgui.get_io()
        io.fonts.add_font_default()

    """
    cdef cimgui.ImFontAtlas* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImFontAtlas* ptr):
        if ptr == NULL:
            return None

        instance = _FontAtlas()
        instance._ptr = ptr
        return instance

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

        return self._ptr != NULL

    def add_font_default(self):
        self._require_pointer()

        return _Font.from_ptr(self._ptr.AddFontDefault(NULL))

    def add_font_from_file_ttf(
        self, str filename, float size_pixels,
        font_config=None,
        glyph_ranges=None
    ):
        self._require_pointer()

        cdef const cimgui.ImWchar* p_glyph_ranges;

        if glyph_ranges is None:
            p_glyph_ranges = NULL
        elif isinstance(glyph_ranges, _StaticGlyphRanges):
            p_glyph_ranges = (<_StaticGlyphRanges>glyph_ranges).ranges_ptr
        elif isinstance(glyph_ranges, GlyphRanges):
            p_glyph_ranges = (<GlyphRanges>glyph_ranges).ranges_ptr
        else:
            raise RuntimeError('glyph_ranges: invalid type')

        cdef cimgui.ImFontConfig config
        if font_config is not None:
            config = (<FontConfig>font_config).config

        return _Font.from_ptr(self._ptr.AddFontFromFileTTF(
            _bytes(filename), size_pixels,  &config,
            p_glyph_ranges
        ))

    def clear_tex_data(self):
        self._ptr.ClearTexData()

    def clear_input_data(self):
        self._ptr.ClearInputData()

    def clear_fonts(self):
        self._ptr.ClearFonts()

    def clear(self):
        self._ptr.Clear()

    def get_glyph_ranges_default(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesDefault())

    def get_glyph_ranges_korean(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesKorean())

    def get_glyph_ranges_japanese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesJapanese())

    def get_glyph_ranges_chinese_full(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesChineseFull())

    def get_glyph_ranges_chinese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesChineseSimplifiedCommon())

    def get_glyph_ranges_cyrillic(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesCyrillic())
    
    def get_glyph_ranges_thai(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesThai())
    
    def get_glyph_ranges_vietnamese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesVietnamese())

    def get_glyph_ranges_latin(self):
        # note: this is a custom glyph range with full latin character set
        return _StaticGlyphRanges.from_ptr(_LATIN_ALL)

    def get_tex_data_as_alpha8(self):
        self._require_pointer()

        cdef int width
        cdef int height
        cdef unsigned char* pixels

        self._ptr.GetTexDataAsAlpha8(&pixels, &width, &height)

        return width, height, bytes(pixels[:width*height])

    def get_tex_data_as_rgba32(self):
        self._require_pointer()

        cdef int width
        cdef int height
        cdef unsigned char* pixels
        self._ptr.GetTexDataAsRGBA32(&pixels, &width, &height)

        return width, height, bytes(pixels[:width*height*4])

    @property
    def texture_id(self):
        """
        Note: difference in mapping (maps actual TexID and not TextureID)

        Note: texture ID type is implementation dependent. It is usually
        integer (at least for OpenGL).

        """
        return <object>self._ptr.TexID


    @property
    def texture_width(self):
        return <int>self._ptr.TexWidth

    @property
    def texture_height(self):
        return <int>self._ptr.TexHeight

    @property
    def texture_desired_width(self):
        return <int>self._ptr.TexDesiredWidth

    @texture_desired_width.setter
    def texture_desired_width(self, int value):
        self._ptr.TexDesiredWidth = value


    @texture_id.setter
    def texture_id(self, value):
        get_current_context()._keepalive_cache.append(value)
        self._ptr.TexID = <void *> value

#-------------------------------------------------------------------------
# [SECTION] ImFontAtlas glyph ranges helpers
#-------------------------------------------------------------------------

# ImFontAtlas methods are mapped in previous section

#-----------------------------------------------------------------------------
# [SECTION] ImFontGlyphRangesBuilder
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] ImFont
#-----------------------------------------------------------------------------

cdef class _Font(object):
    @staticmethod
    cdef from_ptr(cimgui.ImFont* ptr):
        if ptr == NULL:
            return None

        instance = _Font()
        instance._ptr = ptr
        return instance

#-----------------------------------------------------------------------------
# [SECTION] ImGui Internal Render Helpers
#-----------------------------------------------------------------------------
# Vaguely redesigned to stop accessing ImGui global state:
# - RenderArrow()
# - RenderBullet()
# - RenderCheckMark()
# - RenderMouseCursor()
# - RenderArrowPointingAt()
# - RenderRectFilledRangeH()
#-----------------------------------------------------------------------------
# Function in need of a redesign (legacy mess)
# - RenderColorRectWithAlphaCheckerboard()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Decompression code
#-----------------------------------------------------------------------------
# Compressed with stb_compress() then converted to a C array and encoded as base85.
# Use the program in misc/fonts/binary_to_compressed_c.cpp to create the array from a TTF file.
# The purpose of encoding as base85 instead of "0x00,0x01,..." style is only save on _source code_ size.
# Decompression from stb.h (public domain) by Sean Barrett https:#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Default font data (ProggyClean.ttf)
#-----------------------------------------------------------------------------
# ProggyClean.ttf
# Copyright (c) 2004, 2005 Tristan Grimmer
# MIT license (see License.txt in http:# Download and more information at http:#-----------------------------------------------------------------------------
# File: 'ProggyClean.ttf' (41208 bytes)
# Exported using misc/fonts/binary_to_compressed_c.cpp (with compression + base85 string encoding).
# The purpose of encoding as base85 instead of "0x00,0x01,..." style is only save on _source code_ size.
#-----------------------------------------------------------------------------

# Nothing to be mapped here
