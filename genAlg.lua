local genAlg = {
    --Default Parameters
    populationSize = 20,
    generations = 10,
    
    genomeSize = 3,
    geneDomain = { -1, 2 }, --{ x, width }
    
    mutationType = "gaussian", --options: gaussian, shrink 
    mutationRate = 1, --min: 0, max: 1
    mutationStdDev = 1,
    mutationShrink = 0.8, --min: 0, max: 1
    
    selectionType = "linear_ranked", --options: linear_ranked
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
        
        --select parents
        local parents = genAlg._selectParents(population, genAlg.selectionRate)
        

        --crossover
        for i = genAlg.selectionCarryover + 1, genAlg.populationSize, 1 do
            local newChromosome = genAlg._newChromosomeFromParents(parents)
            population[i].score = 0
            population[i].chromosome = newChromosome
        end
    end
end

function genAlg._selectParents(sortedPopulation, rate) 

    local parents = {}
    local numParents = math.ceil(#sortedPopulation * rate)
    
    if genAlg.selectionType == "linear_ranked" then
        local selectionMatrix = {}
        for i = 1, numParents, 1 do
            selectionMatrix[i] = 0;
        end
        while #parents < numParents do
            local n = genAlg.populationSize
            local rand = math.floor(math.abs(genAlg._triangular(-n, n, 0)))
            if (rand <= n and selectionMatrix[rand] == 0) then
                selectionMatrix[rand] = 1
                table.insert(parents, sortedPopulation[rand])
            end
        end
    else
        for i = 1, numParents, 1 do
            parents[i] = sortedPopulation[i]
        end
    end
    
    return parents
end

function genAlg._newChromosomeFromParents(parents)
  local p1 = math.random(#parents)
  local p2 = math.random(#parents)
  while p1 == p2 do
    p2 = math.random(#parents)
  end 
  local newChromosome = {}
  if genAlg.crossoverType == "uniform" then
    for i = 1, genAlg.genomeSize, 1 do
      if math.random() > 0.5 then
        newChromosome[i] = parents[p1].chromosome[i]
      else
        newChromosome[i] = parents[p2].chromosome[i]
      end
    end
  end

  return newChromosome
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
        local dna = {}
        for j = 1, genAlg.genomeSize, 1 do
            dna[j] = math.random() * genAlg.geneDomain[2] + genAlg.geneDomain[1]
        end
        population[i] = { chromosome = dna, score = 0 }
    end
    return population
end