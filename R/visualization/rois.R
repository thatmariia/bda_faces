#' Plot image with ROIs
#' LLM src=https://chatgpt.com/share/6ad02409-b728-83ed-b4c1-fd843380144d
#' @param image Pixel matrix of the image or a file path to the image.
#' @param rois Tibble of ROIs with columns `x_start`, `x_end`, `y_start`, and `y_end`.
#' @param show_labels Whether to show labels for the ROIs.
#' @param label_size Size of the ROI labels.
#' @param frame_size Size of the ROI frames.
#' @param frame_alpha Transparency of the ROI frames.
#' @return A ggplot object with the image and ROIs.
plot_image_rois <- function(
    image,
    rois,
    show_labels = TRUE,
    label_size = 3,
    frame_size = 0.7,
    frame_alpha = 1
) {
    # Load image if a file path is provided
    if (is.character(image) && length(image) == 1) {
        image <- png::readPNG(image)
    }

    # Image dimensions
    img_height <- dim(image)[1]
    img_width  <- dim(image)[2]

    # Convert image to raster
    img_raster <- as.raster(image)

    # ROI coordinates
    rois <- rois %>%
        mutate(
        x_center = (x_start + x_end) / 2,
        y_center = (y_start + y_end) / 2
        )

    # Plot image
    p <- ggplot() +
        annotation_raster(
        img_raster,
        xmin = 0,
        xmax = img_width,
        ymin = img_height,
        ymax = 0
        ) +

        # ROI frames
        geom_rect(
        data = rois,
        aes(
            xmin = x_start,
            xmax = x_end,
            ymin = y_start,
            ymax = y_end,
            color = region
        ),
        fill = NA,
        linewidth = frame_size,
        alpha = frame_alpha
        ) +

        scale_y_reverse(
        limits = c(img_height, 0),
        expand = c(0, 0)
        ) +

        scale_x_continuous(
        limits = c(0, img_width),
        expand = c(0, 0)
        ) +

        coord_fixed() +

        theme_void() +

        theme(
        legend.position = "none"
        )

    # Add labels
    if (show_labels) {
        p <- p +
        geom_label(
            data = rois,
            aes(
            x = x_center,
            y = y_start,
            label = region,
            color = region
            ),
            fill = "black",
            label.size = 0,
            size = label_size,
            vjust = 1.1,
            show.legend = FALSE
        )
    }

    return(p)
}