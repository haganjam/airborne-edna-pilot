
# 01-fieldwork-data

# load the field data from Google Drive
field_data <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1anVTdsjk8Esc0IGHlzMlE2ex8IdbY2-wgBrFSQs-FVA/edit?usp=sharing")
head(field_data)

# assign a sample-id
field_data$subject_id <- rep(1:(nrow(field_data)/16), each = 16)

# pivot to a wider format
field_data <-
  field_data |>
  tidyr::pivot_wider(id_cols = "subject_id",
                     names_from = "question_id",
                     values_from = "response")

# relabel the site value
field_data <-
  field_data |>
  dplyr::mutate(site_label = dplyr::case_when(
    site == "vrango" ~ "vr",
    site == "saltholmen" ~ "st",
    site == "nya varvet" ~ "nv",
    site == "natrium" ~ "na"
  ))

# relabel the filter_control variable
field_data <-
  field_data |>
  dplyr::mutate(filter_control = dplyr::case_when(
    filter_control == "no" ~ "sample",
    filter_control == "yes"  ~ "control"
  ))

# create a unique site variable
field_data$unique_id <-
  with(field_data,
       paste(segment, date, site_label, sample_number, filter_control, sep = "_"))

# reorganise the data.frame
names(field_data)
field_data <-
  field_data |>
  dplyr::select(subject_id, unique_id, season, test, segment,
                site, site_label, date, filter_control, sample_number, time, lat, lon,
                weather, person, depth, volume, physical, other)
head(field_data)


