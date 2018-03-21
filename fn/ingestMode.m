function ingestMode (weights, tint1, tint2,  key, electrode_group, n_units,label, num)
subject_id = key.subject_id;
session = key.session;

for i_u = 1:1:n_units
    key(i_u).subject_id = subject_id;
    key(i_u).session = session;
    key(i_u).electrode_group = electrode_group (i_u);
    key(i_u).unit = i_u;
    key(i_u).mode_type_name = label;
    key(i_u).mode_unit_weight = weights (i_u);
    key(i_u).mode_time1_st = tint1 (1);
    key(i_u).mode_time1_end = tint1 (2);
    key(i_u).mode_time2_st = tint2 (1);
    key(i_u).mode_time2_end = tint2 (2);
    key(i_u).mode_uid = num;
end
insert(ANL.Mode,key);