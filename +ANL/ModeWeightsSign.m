%{
#
mode_weights_sign                         : varchar(400)      # mode weights sign
---
mode_weights_sign_description=null        : varchar(4000)     #
%}


classdef ModeWeightsSign < dj.Lookup
    properties
        contents = {
            'all'                              'all weights, positive and negative'
            'positive'                         'positive weights (i.e. cell activity is higer for right trials compared to left trials)'
            'negative'                         'negative weights (cell activity is higer for left trials compared to right trials)'
            }
    end
end