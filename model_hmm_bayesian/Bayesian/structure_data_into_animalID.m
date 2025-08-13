function datasub=structure_data_into_animalID(datacell)

animalIDWT=cellfun(@(x)x.ID,datacell,'UniformOutput',false);

unianimalIDWT=unique(animalIDWT);

for i=1:length(unianimalIDWT)
    datasub.(strcat('n',unianimalIDWT{i}))={datacell{strcmp(animalIDWT,unianimalIDWT{i})}};
end

end