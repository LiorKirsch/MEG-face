function showWeights(weightVector, dim1, dim2,dim1_label,dim2_label)
    as2D = reshape(weightVector, dim1,dim2);
    imagesc(as2D);
    colorbar;
    xlabel(dim1_label);
    ylabel(dim2_label);
end