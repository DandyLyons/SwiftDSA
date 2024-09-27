@preconcurrency import Benchmark
import SwiftDSA

@MainActor let benchmarks = {
    Benchmark.defaultConfiguration = .init(
        timeUnits: .microseconds,
        maxDuration: .seconds(100),
        maxIterations: 100_000,
        setup: nil,
        teardown: nil
    )
    
    Benchmark("countFrequency") { benchmark in
        let array = (1...1_000)
            .map { _ in Int.random(in: -100...100) }
        
        benchmark.startMeasurement()
        blackHole(array.countFrequency())
        benchmark.stopMeasurement()
    }
    
//    Benchmark("countFrequency (parallel)") { benchmark in
//        let array = (1...benchmark.currentIteration)
//            .map { _ in Int.random(in: -100...100) }
//        
//        benchmark.startMeasurement()
//        await blackHole(array.countFrequency())
//        benchmark.stopMeasurement()
//    }
}
