local genAlg = {
    --Default Parameters
    populationSize = 20,
    generations = 10,
    
    genomeSize = 3,
    geneDomain = { -1, 2 }, -- { x, width }
    
    mutationType = "gaussian", --options: gaussian, shrink 
    mutationRate = 1, --min: 0, max: 1
    mutationStdDev = 1,
    mutationShrink = 0.8 --min: 0, max: 1
    
    selectionType = "rank", "shrink" --options: rank, shrink
    selectionDistribution = "gaussian", --options: none, triangular, gaussian
    selectionCarryover = 1, --how many of the best performers are carried over without modification
    selectionRate = 0.2, --min: 0, max: 1
    selectionStdDev = 0.2, --min: 0, max: 1
    selectionShrink = 0.8, --min: 0, max: 1
    
    crossoverType = "uniform", --options: uniform
    
    fitnessFunction = nil,
}

function genAlg.run()
    local data = {
        topScores = {},
        meanScores = {},
        variances = {}     
    }
    local population = genAlg._randomPopulaton()
    for genNum = 1, genAlg.generations, 1 do
        --rank creatures
        local scoreTotal = 0
        for i = 1, genAlg.populationSize, 1 do
            local creature = population[i]
            local score = genAlg.fitnessFunction(creature.genes)
            creature.score = score
            scoreTotal = scoreTotal + score
        end
        
        --statistics
        local average = scoreTotal / genAlg.populationSize
        data.meanScores[genNum] = average
        local totalSquaredDev = 0
        for i = 1, genAlg.populationSize, 1 do
            local creature = population[i]
            local score = genAlg.fitnessFunction(creature.genes)
            totalSquaredDev = totalSquaredDev + (score - average)^2
        end
        local variance = totalSquaredDev / genAlg.populationSize
        data.variances[genNum] = variance
        
        
        --sort creatures
        genAlg._quicksort(population)
        local topScore = population[1]
        data.topScores[genNum] = topScore
        
        --elitist carryover
        local nextGeneration = {}
        for i = 1, genAlg.selectionCarryover, 1 do
            table.insert(nextGeneration, population[i])
        end
        
        --select parents
        local parents = {}
        local numParents = math.ceil(genAlg.populationSize * genAlg.selectionRate)
        if genAlg.selectionIsStochastic then
            while #parents < numParents do
                local creature = genAlg._selectCreature(population)
                local selectionOdds = 1 - i / (genAlg.populationSize + 1)
                if (math.random() < selectionOdds then
                
                end
                
            end
        else
            for i = 1, numParents, 1 do
                parents[i] = population[i]
            end
        end
        
    end
end

function genAlg._gaussian(mean, variance)
    return  math.sqrt(-2 * variance * math.log(math.random())) *
            math.cos(2 * math.pi * math.random()) + mean
end

function genAlg._triangular(a, b, c)
  local f = (c - a)/(b - a)
  local rand = math.random()
  local x
  if rand < f then
    x = a + math.sqrt(rand*(b - a)*(c - a))
  else
    x = b - math.sqrt((1 - rand)*(b - a)*(b - c))
  end
  return x
end

function genAlg._quicksort(population, left, right)
    left = left or 1
    right = right or #population
    if right > left then
        local x = population[right].score
        local i = left - 1
        for j = left, right - 1 do
            if population[j].score > x then
                i = i + 1
                local temp = population[i]
                population[i] = population[j]
                population[j] = temp
            end
        end
        local temp = population[i + 1]
        population[i + 1] = population[right]
        population[right] = temp
        local pivotNewIndex = i + 1
        genAlg._quicksort(population, left, pivotNewIndex - 1)
        genAlg._quicksort(population, pivotNewIndex + 1, right)
    end
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