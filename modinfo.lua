name = "Pigman Marketplace"
description = "Adds a marketplace for you to trade for materials"
author = "Teh Scot"
version = "0.1"
forumthread = "N/A"
api_version = 6
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dont_starve_compatible = true
reign_of_giants_compatible = true

configuration_options =
{
    {
        name = "mode",
        label = "Mod Mode",
        options = 
        {
            {description = "Default", data = "basic_mode"}, 
            {description = "Customized", data = "advanced_mode"}
        }, 
        default = "basic_mode",
    },
    {
		name = "twattish",
        label = "Is Crawford a twat?",
        options = 
        {
            {description = "Yes", data = "twat-yes"}, 
            {description = "No", data = "twat-no"}
        }, 
        default = "basic_mode",
    }
}