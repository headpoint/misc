plot_contour <- function(model, data, clust = NULL) {
  
  if (is.null(clust)) 
    if (!is.null(model$clust))
      clust <- model$clust
    
    p <- dim(data)[2]
    g <- dim(fit$sigma)[3]
    df <- data.frame(data, clust = as.factor(clust))
    
    gp <- GGally::ggpairs(df, columns = 1 : p, 
                  upper = list(continuous = "density", combo = "box_no_facet"),
                  aes(colour = clust))
    
    colnam <- colnames(df)
    for (j in 1 : p) {
      for(i in 1 : p) {
        if (i <= j)
          next
        
        pt <- ggplot2::ggplot(df, aes_string(x = colnam[i], y = colnam[j]))
        pt <- pt + ggplot2::geom_point(aes(col = clust))
        
        for (indg in 1 : g) {
          mat <- ellipse::ellipse(fit$sigma[c(i, j), c(i, j), indg], 
                                      centre = fit$mu[c(i, j), indg])
          mat <- as.data.frame(mat)
          colnames(mat) <- colnam[c(i, j)]
          pt <- pt + ggplot2::geom_path(data = mat)
        }
        
        gp[j, i] <- pt
      }
    }
    return(gp)
}