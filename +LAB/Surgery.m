%{
# 
-> LAB.Subject
surgery_id                  : int                           # surgery number
---
-> LAB.Person
start_time                  : datetime                      # start time
end_time                    : datetime                      # end time
description                 : varchar(256)                  # 
%}


classdef Surgery < dj.Manual
end