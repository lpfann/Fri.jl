module dataset

struct Data
    X
    y
end

function generate(n::Integer=100; d_rel::Integer=3, d_irrel::Integer=3, d_weak::Integer = 2 )
    
    X = randn((n,d_rel+(d_weak>0)))
    y = sum(X,dims=2) .> 0;
    y = convert.(Int, y)
    y[y .== 0] .= -1;

    irrel = randn((n,d_irrel))

    if d_weak>0
        cofactors = 1 .+ randn((d_weak),)
        strong = X[:,end]
        weak = repeat(strong, 1,2)
        #for i in d_weak
        #    weak[:,i] *= cofactors[i]
        #end
        [X[:,1:end-1] weak irrel],y
    else
        [X irrel],y
    end
end

end