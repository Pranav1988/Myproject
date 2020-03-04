#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[3]:


import json


# In[5]:


data = pd.read_json('D:\SpringBoard_Home\Mini Project 1(Json)\data_wrangling_json\data\world_bank_projects.json')


# In[7]:


data.head()


# In[48]:


country = data.groupby('countryname',as_index =False)[['project_name']].count()


# In[49]:



country.sort_values(by = "project_name",ascending =False)[:10]


# In[153]:


Data_For_Normalisation = json.load(open('D:\SpringBoard_Home\Mini Project 1(Json)\data_wrangling_json\data\world_bank_projects.json'))


# In[242]:



from pandas.io.json import json_normalize
Project_themes = json_normalize(Data_For_Normalisation,record_path = 'mjtheme_namecode')
# converting "code" as int before setting it to index
Project_themes['code'] = Project_themes['code'].map(lambda x: int(x))
Project_themes = Project_themes.set_index('code')
Project_themes


# In[246]:


#Finding Unique Themes 

import numpy

Unique_name = numpy.delete(Project_themes.name.sort_index().unique(),[0])


# In[247]:


Unique_name


# In[249]:


# Making dictionary of unique codes and theme names
Unique_dict = {}

for index,element in enumerate(Unique_name,start = 1):
    Unique_dict[index]= element


# In[250]:


Unique_dict


# In[312]:


# Filling blank vlues with correct names


def replace_name(df,code_dict):
    
    for key,val in code_dict.items():
        df_temp = df[(df.code==key) & (df.name=='')]     
        df.loc[df_temp.index.tolist(), 'name']=val
   
    return df


Project_themes = replace_name(Project_themes,Unique_dict)
Project_themes[Project_themes.name =='']
    


# In[ ]:




