local genAlg = {
    --Default Parameters
    populationSize = 20,
    generations = 10,
    
    genomeSize = 3,
    geneDomain = { -1, 2 }, -- { x, width }
    
    mutationType = "gaussian", --options: gaussian, shrink 
    mutationRate = 1, --min: 0, max: 1
    mutationShrink = 0.5 --min: 0, max: 1
    
    selectionType = "uniform", --options: uniform, boltzmann 
    selectionStochastic = true,
    selectionCarryOver = 1, --how many of the best performers are carried over without modification
    selectionRate = 0.2, --min: 0, max: 1
    selectionShrink = 0.8, --min: 0, max: 1
    
    crossoverType = "uniform", --options: uniform
    
    fitnessFunction = nil,
}

function genAlg.run()
    local data = {
        topScores = {},
        population = genAlg._randomPopulaton(),
        
    }
    for genNum = 1, genAlg.generations, 1 do
        --rank creatures
        for creatureNum = 1, genAlg.populationSize, 1 do
            local creature = data.population[creatureNum]
            creature.score = genAlg.fitnessFunction(creature.genes)
        end
        
        --sort creatures
        genAlg._sortPopulation(data.population)
        
        --select creatures
        local parents = {}
        for creatureNum = 1, genAlg.populationSize, 1 do
            local creature = data.population[creatureNum]
            
        end
    end
end

function genAlg._gaussian(mean, variance)
    return  math.sqrt(-2 * variance * math.log(math.random())) *
            math.cos(2 * math.pi * math.random()) + mean
end

function genAlg._randomPopulaton()
    local population = {}
    for i = 1, genAlg.populationSize, 1 do
        local _dna = {}
        for j = 1, genAlg.genomeSize, 1 do
            dna[j] = math.random() * genAlg.geneDomain[2] + genAlg.geneDomain[1]
        end
        population[i] = { genes = dna, score = 0 }
    end
    return population
end