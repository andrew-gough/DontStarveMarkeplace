name = "Pigman Marketplace"
description = "Adds a marketplace for you to trade for materials"
author = "Teh Scot"
version = "0.1"
forumthread = "N/A"
api_version = 6
icon_atlas = "iconImage.xml"
icon = "iconImage.tex"
dont_starve_compatible = true
reign_of_giants_compatible = true

configuration_options =
{
	{
		name = "recipeDifficulty",
        label = "Recipe Difficulty",
        options = 
        {
            {description = "Cheaty", data = "diffCheaty"}, 
            {description = "Easy", data = "diffEasy"},
			{description = "Medium", data = "diffMedium"},
			{description = "Hard", data = "diffHard"},
        }, 
        default = "diffMedium",
    },
	{
		name = "sellValue",
        label = "Selling Value",
        options = 
        {
            {description = "100% of Buying", data = "sell100"}, 
            {description = "75% of Buying", data = "sell75"},
			{description = "50% of Buying", data = "sell50"},
			{description = "25% of Buying", data = "sell25"},
			{description = "Disable Selling", data = "sell0"},
        }, 
        default = "sell50",
    },
	{
		name = "cutgrass",
        label = "Cut Grass Trading",
        options = 
        {	
			{description = "Don't Trade", data = "noTrade"},
			{description = "1 Gold for 40", data = "1Gfor40"}, 
			{description = "1 Gold for 20", data = "1Gfor20"}, 
			{description = "1 Gold for 10", data = "1Gfor10"}, 
		    {description = "1 Gold for 5", data = "1Gfor5"}, 
            {description = "1 Gold for 2", data = "1Gfor2"}, 
			{description = "1 Gold for 1", data = "1Gfor1"}, 
			{description = "2 Gold for 1", data = "2Gfor1"}, 
			{description = "3 Gold for 1", data = "3Gfor1"}, 
			{description = "5 Gold for 1", data = "5Gfor1"}, 
			{description = "10 Gold for 1", data = "10Gfor1"},
			{description = "20 Gold for 1", data = "20Gfor1"},	
			{description = "30 Gold for 1", data = "30Gfor1"},
			{description = "50 Gold for 1", data = "50Gfor1"},
			{description = "100 Gold for 1", data = "100Gfor1"},
			{description = "200 Gold for 1", data = "200Gfor1"},
			{description = "Don't Trade", data = "noTrade"},
        }, 
        default = "1Gfor40",
    },
	{
		name = "rocks",
        label = "Rocks Trading",
        options = 
        {	
			{description = "Don't Trade", data = "noTrade"},
			{description = "1 Gold for 40", data = "1Gfor40"}, 
			{description = "1 Gold for 20", data = "1Gfor20"}, 
			{description = "1 Gold for 10", data = "1Gfor10"}, 
		    {description = "1 Gold for 5", data = "1Gfor5"}, 
            {description = "1 Gold for 2", data = "1Gfor2"}, 
			{description = "1 Gold for 1", data = "1Gfor1"}, 
			{description = "2 Gold for 1", data = "2Gfor1"}, 
			{description = "3 Gold for 1", data = "3Gfor1"}, 
			{description = "5 Gold for 1", data = "5Gfor1"}, 
			{description = "10 Gold for 1", data = "10Gfor1"},
			{description = "20 Gold for 1", data = "20Gfor1"},	
			{description = "30 Gold for 1", data = "30Gfor1"},
			{description = "50 Gold for 1", data = "50Gfor1"},
			{description = "100 Gold for 1", data = "100Gfor1"},
			{description = "200 Gold for 1", data = "200Gfor1"},
			{description = "Don't Trade", data = "noTrade"},
        }, 
        default = "1Gfor40",
    },
	{
		name = "dug_sapling",
        label = "Sapling Trading",
        options = 
        {	
			{description = "Don't Trade", data = "noTrade"},
			{description = "1 Gold for 40", data = "1Gfor40"}, 
			{description = "1 Gold for 20", data = "1Gfor20"}, 
			{description = "1 Gold for 10", data = "1Gfor10"}, 
		    {description = "1 Gold for 5", data = "1Gfor5"}, 
            {description = "1 Gold for 2", data = "1Gfor2"}, 
			{description = "1 Gold for 1", data = "1Gfor1"}, 
			{description = "2 Gold for 1", data = "2Gfor1"}, 
			{description = "3 Gold for 1", data = "3Gfor1"}, 
			{description = "5 Gold for 1", data = "5Gfor1"}, 
			{description = "10 Gold for 1", data = "10Gfor1"},
			{description = "20 Gold for 1", data = "20Gfor1"},	
			{description = "30 Gold for 1", data = "30Gfor1"},
			{description = "50 Gold for 1", data = "50Gfor1"},
			{description = "100 Gold for 1", data = "100Gfor1"},
			{description = "200 Gold for 1", data = "200Gfor1"},
			{description = "Don't Trade", data = "noTrade"},
        }, 
        default = "1Gfor1",
    },
	{
		name = "log",
        label = "Log Trading",
        options = 
        {	
			{description = "Don't Trade", data = "noTrade"},
			{description = "1 Gold for 40", data = "1Gfor40"}, 
			{description = "1 Gold for 20", data = "1Gfor20"}, 
			{description = "1 Gold for 10", data = "1Gfor10"}, 
		    {description = "1 Gold for 5", data = "1Gfor5"}, 
            {description = "1 Gold for 2", data = "1Gfor2"}, 
			{description = "1 Gold for 1", data = "1Gfor1"}, 
			{description = "2 Gold for 1", data = "2Gfor1"}, 
			{description = "3 Gold for 1", data = "3Gfor1"}, 
			{description = "5 Gold for 1", data = "5Gfor1"}, 
			{description = "10 Gold for 1", data = "10Gfor1"},
			{description = "20 Gold for 1", data = "20Gfor1"},	
			{description = "30 Gold for 1", data = "30Gfor1"},
			{description = "50 Gold for 1", data = "50Gfor1"},
			{description = "100 Gold for 1", data = "100Gfor1"},
			{description = "200 Gold for 1", data = "200Gfor1"},
			{description = "Don't Trade", data = "noTrade"},
        }, 
        default = "1Gfor40",
    },
	
}