
# GTD - Global Terrorism Database

### Context

An open-source database including information on terrorist attacks around the world from 1970 through 2017.
It includes information on more than 180,000 terrorist events.

The database is maintained by researchers at the National Consortium for the Study of Terrorism
and Responses to Terrorism (START), headquartered at the University of Maryland.

Definition of terrorism:

"The threatened or actual use of illegal force and violence by a non-state actor to attain a political, economic, religious, or social goal through fear, coercion, or intimidation."

### Content

Geography: Worldwide

Time period: 1970-2017, except 1993 (files were lost)

Unit of analysis: Attack

Variables: more than 100 variables on location, tactics, perpetrators, targets, and outcomes.

For clarity, only the following are used in the dashboard:

attacktype1_txt : text
city            : text
country_txt     : text
eventid         : uuid
gname           : text
imonth          : number
individual      : boolean
iyear           : number
nkill           : number
region_txt      : text
success         : boolean
suicide         : boolean
weaptype1_txt   : text

See the [GTD Codebook](https://www.start.umd.edu/gtd/downloads/Codebook.pdf) for important details on data collection methodology, definitions, and coding schema.
