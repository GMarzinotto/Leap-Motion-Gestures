function [features] = read_preprocess_and_feature_extract_digit(path)

    readfile  = read_database_file(path);
    centred   = center_digit(readfile);
    firstPCA  = principal_components_digit(centred);
    rescale   = rescale_digit(firstPCA);
    filtered  = filter_digit(rescale);
    resampled = resample_digit(filtered);
    final     = principal_components_digit(resampled);
    features  = feature_extraction_digit(final);
    
end