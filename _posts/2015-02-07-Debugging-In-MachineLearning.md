---
layout: post
section: blog
title: "Debugging Numerical Code in Machine Learning"
---

# {{page.title}}

<i>(Warning: Somewhat hastily written. Will fix this soon..) </i><br>

Numerical programming and debugging is pretty tricky and doing it well is definitely an art! I am trying to learn this myself myself and wanted to add a perspective from my side.

In most machine learning methods, there are essentially three main pieces of code that get written in slightly different variations; 
<ul>
<li>First part: where you read the dataset, initialize your parameters, setup random # generators, etc.</li>
<li>Second part: where you calculate your objective function and your gradient.</li> 
<li>Third part: where you evaluate your model on test data (by calculating measures like F-score, NDCG, etc).</li>
</ul>

First of all, make sure you read the data correctly. A good practice is to print the description of the dataset to the screen (for each train, test and validation datasets - # of examples, # of features, # of classes). This will help you catch some early errors. Also, use a small sub-set of the data until you get your algorithm working correctly. Later, you can swap it with the full dataset. This will help in case you want to print out computations per data point and check manually if there is something wrong.

If you are generating random numbers, then you should use a <i>deterministic seed</i>. Do not use time as a seed. This is very important because although your algorithm will make use of non-determinism and randomness, it makes   debugging painfully hard as the intermediate results will keep changing everytime you run it. So, assign a deterministic seed. This will also help others reproduce your research results if they need to, at a later point.

When debugging an optimizer for example, look at how the objective function value evolves as the iterations increase. If it behaves in an unexpected manner, the first thing to do would be to check your gradient calculation code (also check the code that calculates your obj function. Often there are terms computed in common which are used to calculate both obj function and the gradient!). One way to debug gradients is to manually write down the obj function equation, its gradient and compare term by term what you are computing. Assign some values to the parameters and check the output. But, the better approach (recommended) is to use <i>Finite Gradient Check</i> (Leon Bottou describes it in section 4.2 of this <a href="http://research.microsoft.com/pubs/192769/tricks-2012.pdf">paper</a>). From my experience, this eliminates most of the problems.
Note that norm of the gradient will be close to zero at the optimum, so you can use it to check if you are there yet (but this can be a false positive if there is a local minima!)

If your objective function is non-convex, then there is chance you end up in local-minima. So if you do not get the expected obj value at the end, instead of fixed initialization of the weights, try random initialization, or initialize it with the final weights of another model that works correctly! One of these might help you get out of the local-optimum.

Check your step-size (learning rate) and make sure you do not set it too large. This might be more complicated to handle if you are implementing SGD or related methods in which case you can try step-tuning methods like AdaGrad, etc.

Other issues in the code could be:
<ul>
<li>Floating point truncation issues (check if you are dividing by integers and it accidently causes the result to be rounded off to an integer! - when what you want is a float value).</li>
<li>Underflow/Overflow problems (this happens mostly when your objective function computes exp(x) or log(x)). Notice that log of a very small number can lead to -ve inf (or +ve inf vice-versa). exp() is a very fast growing function and even exp(80) or exp(100) can easily overflow. So you need to take care of that. Often exp() terms are computed over data points in some way, so if you normalize the data so that the features lie between 0-1, this can be avoided to some extent, but how to avoid this exactly - depends on your function.</li>
<li>If you calculate the log-sum-exp function for example in logistic regression, you can use the max-trick to avoid overflow (More details here: <a href="http://jblevins.org/log/log-sum-exp">http://jblevins.org/log/log-sum-exp</a>).</li>
</ul>

Plot obj function value vs iterations, accuracy vs iterations. That should give an idea of how your optimizer is proceeding.

Most of the above points help in debugging the optimizer part of your code, however you can still obtain poor model accuracy even if your optimizer is working correctly! This is because your model can overfit or underfit. You can check that by observing the train and test error. If train error decreases continously while test error increases => your model is overfitting and you need to add more regularization. You can avoid this check by also running your model over a wide range of regularization values (say: 10^-8, 10^-5, 10^-1, 1, 10^2, 10^5) and see which one works best; keep that value.

Distinction between model and an optimizer: 
By model, I mean the objective function; you want to setup the right function (say logistic regression or svm or etc) with the right regularizers (to avoid overfitting/underfitting) so that you can get the best performance (a.k.a accuracy). Here, you may or may not care about time.

By optimizer, I mean the solver (say gradient-descent, SGD, L-BFGS, etc) that takes the model (or objective function) and produces the final weights (or optimal value). As you can see, regularization may not matter much here as it will only change the value of the objective function. What matters here is given any function, how <i>correctly</i> and <i>quickly</i> can we find the optimal solution?

These are some of my suggestions, I hope to add more later. Comments are welcome.

