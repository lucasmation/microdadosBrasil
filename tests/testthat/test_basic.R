context("Metadata works")

test_that("metadata is correctly readed", {
  expect_equal(class(read_metadata("PNAD")), "data.frame")

})

test_that("dataset metadata is all stored", {
  expect_true(all(c("PNAD","CENSO","CAGED","RAIS","PME","POF","CensoEscolar","PNADcontinua", "POF") %in% get_available_datasets()))

})



