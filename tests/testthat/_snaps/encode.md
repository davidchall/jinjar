# dynamic dots work

    Code
      encode(a = 1, a = "b")
    Condition
      Error in `encode()`:
      ! Arguments in `...` must have unique names.
      x Multiple arguments named `a` at positions 1 and 2.

---

    Code
      encode(a = 1, "b", mtcars)
    Condition
      Error in `encode()`:
      ! All data variables must be named.
      x Unnamed variables: `b` and `mtcars`

# data validation works

    Code
      encode(a = mean)
    Condition
      Error in `encode()`:
      ! Data variable `a` is unsupported.
      x `a` is a function.
      i Choices: NULL, logical, integer, double, character, list, dataframe.

