img_dir = 'd:\GDrive\MyWebsite\UnderwaterColorRestoration\files\';

methods = {'NT16_AnCo_RF_10_guetzli'; ...
    'UWCT_ICIP2017_img_00495cDCP_';
    'SF_Ancuti_CVPR_TIP_16_guetzli'};
im_names = {'DSC3353', 'DSC3212', 'RGT3858'};

table_of_angles = measure_angles('MacbethQP_average', im_names, methods); 
angle_func = @(x) acosd(nanmedian(x));

scale_factor = 0.25;

for img_idx = 1:length(im_names)
    image_name = im_names{img_idx};
    disp(['Image name: ', image_name]);
    fileparams = load([img_dir, image_name, '_params.mat']);
    for i_method = 1:length(methods)
        img = im2double(imread([img_dir, image_name, '_', methods{i_method}, '.jpg']));
        for kk = 1:length(fileparams.color_chart)
            color_chart = fileparams.color_chart{kk};
            col_idx = table_of_angles.col_header(image_name, color_chart);
            reflectance_coeffs = fileparams.(['reflectance_coeffs','_',color_chart]);
            grayscale_coordinates = fileparams.(['grayscale_coordinates','_',color_chart]);
            angles = calc_grayscale_patch_results(img, grayscale_coordinates.*scale_factor);
            table_of_angles.insert_val( angle_func(angles), methods(i_method), col_idx);
         end
    end
end

table_of_angles.disp()