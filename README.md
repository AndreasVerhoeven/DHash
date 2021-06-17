# DHash
Compares two UIImages using a simple DHash implementation



## What?

Sometimes you want to check if two images are "kind of" similar, especially when JPEG compression can kick it. This small library makes that possible using a DHash (dynamic hash) fingerprint.

## How?

We calculate the 8x8 dhash of both images and compare them using a treshold. A dhash is a dynamic "fingerprint" hash. A dhash basically compares the changes in "gradients".


## Example:
```
let image1 = UIIMage(...)
let image2 = UIImage(...)

let matches: Bool = image1.seemsSimilarTo(image2)
print(matches)
```
