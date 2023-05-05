# Chamois

I am updating the models with the new weather station from Acquarossa / Comprovasco

Hello Pierre,

I tried running the model to add an extra temperature effect to the simplest linear model (no year as fixed or random)… and there is a new time window in the spring/summer the chamois is shot!
So there would be an effect of T during lactation and during the second summer… pretty nice! (Attached!!)

What do you think? Is there anything else interesting you’d try?
Have you thought more about the “year” effect? I am still struggling to decide, as I feel I don’t have a good grasp of how different the two relationships with climate are… What is year adding or removing...

Pierre  24.02.2023

I finally found time to look at the papers you sent and your script. I would go for the “simple” linear models and keep the results presented in your script. Adding the year as random or fixed effects is identifying the within-year contribution of climates, with the weight of the chamois being influenced by the spring temperature the year they were killed. However, our question is on how does changes over the years influence the weight of chamois, which is why I would go for the “simple model” that allows testing for between years effects.

I think, should you be interested to see if the effects are driven by climatic effects per se, you can detrend the climatic (i.e. extract the residuals of clim ~ year) and phenotypic (i.e. extract residuals of weight ~year) data of your best model, and then look at the relationship between MASSresiduals ~ CLIMresiduals. If you still see the same relationship as in your panel(s) a and b, then you know for sure that changes in temperature over the years are causing the change in body mass of the years.

If the relationship is not anymore present, it’s difficult to conclude whether the change in mass may or may not be caused by a change in temperature

“ A significant relationship between year-detrended climate and phenology variables (i.e., the residuals) indicates that year is not confounding the original climate–phenology relationship. In contrast, if there is no relationship between year-detrended climate and phenology variables, then the effects of year and climate on phenology cannot be disentangled given the available observational data from [[https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecy.1690](https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecy.1690)](%5B[https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecy.1690%5D(https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecy.1690))](https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecy.1690%5D(https://esajournals.onlinelibrary.wiley.com/doi/full/10.1002/ecy.1690))) “
