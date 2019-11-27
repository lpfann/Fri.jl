using Fri
using Fri.dataset

X,y = Fri.dataset.generate(100,d_rel=2,d_irrel=2,d_weak=2);

bounds = Fri.relevance_bounds(X,y)
@test len(bounds) == shape(X)[2]