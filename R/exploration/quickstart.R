lapply(image_files$train, str)
str(image_files$test)

example_files <- c(
  image_files$train$happy[60], image_files$train$sad[61],
  image_files$train$anger[61], image_files$train$disgust[61]
)
example_names <- c("happy.png", "sad.png", "anger.png", "disgust.png")
file.copy(example_files, file.path(output_dir, example_names), overwrite = TRUE)
if (isTRUE(getOption("jupyter.in_kernel"))) {
  IRdisplay::display_html(paste0(
    '<img src="', example_names, '" width="200" style="float:left" />',
    collapse = ""
  ))
} else if (isTRUE(getOption("knitr.in.progress"))) {
  knitr::include_graphics(file.path(output_dir, example_names))
}

img <- readPNG(image_files$train$happy[4])
glimpse(img)
options(repr.plot.width = 5, repr.plot.height = 5)
# Visualize the structure of color images
layout(matrix(1:4, 2))
paint_image(img)
paint_image(img, colors = 1)
paint_image(img, colors = 2)
paint_image(img, colors = 3)

# Download a semi transparent picture of an parrot
parrot_file <- file.path(output_dir, "semitransp.png")
if (!file.exists(parrot_file)) {
  download.file("https://i.imgur.com/2EHoMKi.png", destfile = parrot_file, mode = "wb")
}
parrot <- readPNG(parrot_file)
str(parrot)
# Draw the parrot itself, and as an overlay over a scatterplot
options(repr.plot.width = 15, repr.plot.height = 3)
layout(t(1:5))
# Parrot itself
paint_image(parrot, colors = 1:4)
paint_image(parrot, colors = c(1, 4))
paint_image(parrot, colors = c(2, 4))
paint_image(parrot, colors = c(3, 4))
# Parrot as an overlay on top of a plot (randomly generated for demonstration purposes)
plot(runif(100), runif(100))
rasterImage(parrot, 0, 0, 1, 1)


# Check the result (are X, X_test, and y what we expect?)
x_train[1:6, 20:23] |> print()
table(y)
x_test[1:6, 20:23] |> print()
options(repr.plot.width = 4, repr.plot.height = 4)
layout(1)
as_image(x_train[13, ])
as_image(x_test[13, ])

# Set plot dimensions
options(repr.plot.width = 16, repr.plot.height = 4)

# Compute edges by differencing neighboring pixels
im <- matrix(x_train[756, ], 48)
edges <- image_edges(im)

# Threshold for edge detection
threshold <- 0.0625

# Display images in a 1x4 layout
layout(t(1:4))
as_image(im)
as_image(edges$horizontal < threshold, 47)
mtext("horizontal edge pixels")
as_image(edges$vertical < threshold, 48)
mtext("vertical edge pixels")
as_image(edges$diagonal < threshold / 2, 47)
mtext("diagonal edge pixels")

FreySlateFeatures(edges$horizontal < threshold)
