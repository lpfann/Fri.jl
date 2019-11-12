using fri
using fri.dataset

X,y = fri.dataset.generate(100,d_rel=2,d_irrel=2,d_weak=2);

fri.relevance_bounds(X,y)