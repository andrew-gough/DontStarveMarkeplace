PrefabFiles = {"marketplace"}


		STRINGS = GLOBAL.STRINGS
        RECIPETABS = GLOBAL.RECIPETABS
        Recipe = GLOBAL.Recipe
        Ingredient = GLOBAL.Ingredient
        TECH = GLOBAL.TECH

        STRINGS.NAMES.MARKETPLACE = "Marketplace"
		
        STRINGS.RECIPE_DESC.MARKETPLACE = "The pigman market!"
		
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.MARKETPLACE = "Should I say hi?"
		
	
		local marketplace = Recipe("marketplace",{ Ingredient("cutgrass", 1)},
		RECIPETABS.LIGHT, TECH.NONE,"marketplace_placer")
		