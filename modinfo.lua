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
			{description = "Hard", data = "diffHard"},
        }, 
        default = "diffHard",
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
		name = "barterValues",
        label = "BarterValues",
        options = 
        {
            {description = "Default", data = "barterDefault"}, 
            {description = "Custom", data = "barterCustom"},
        }, 
        default = "barterDefault",
    },
	{
		name = "tradecutGrass",
        label = "Cut Grass Trading",
        options = 
        {	
			{description = "1 Gold for 40", data = "trade1Gfor40"}, 
			{description = "1 Gold for 20", data = "trade1Gfor20"}, 
			{description = "1 Gold for 10", data = "trade1Gfor10"}, 
		    {description = "1 Gold for 5", data = "trade1Gfor5"}, 
            {description = "1 Gold for 2", data = "trade1Gfor2"}, 
			{description = "1 Gold for 1", data = "trade1Gfor1"}, 
			{description = "2 Gold for 1", data = "trade2Gfor1"}, 
			{description = "3 Gold for 1", data = "trade3Gfor1"}, 
			{description = "5 Gold for 1", data = "trade5Gfor1"}, 
			{description = "10 Gold for 1", data = "trade10Gfor1"},
			{description = "20 Gold for 1", data = "trade20Gfor1"},	
			{description = "30 Gold for 1", data = "trade30Gfor1"},
			{description = "50 Gold for 1", data = "trade50Gfor1"},
			{description = "100 Gold for 1", data = "trade100Gfor1"},
			{description = "200 Gold for 1", data = "trade200Gfor1"},
        }, 
        default = "trade1Gfor40",
    },
	
}