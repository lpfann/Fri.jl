using Fri, Test
using Fri.dataset

function test_fit()

    X,y = Fri.dataset.generate(40,d_rel=2,d_irrel=2,d_weak=2);

    bounds = Fri.relevance_bounds(X,y)
    @test size(bounds) == (size(X)[2],2)
end

test_fit()