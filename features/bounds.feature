Feature: Bounds

  Scenario: bounds<point, point> creates new bounds with given bounds
    Given pmin ← point<-1, -1, -1>
    And pmax ← point<1, 1, 1>
    When b ← bounds<pmin, pmax>
    Then b.min = pmin
    And b.max = pmax

  Scenario: Transforming bounds by translation
    Given b ← bounds<point<-1,-1,-1>, point<1,1,1>>
    And t ← translation<2, 2, 2>
    When tb ← b.transform<t>
    Then tb.min = point<1, 1, 1>
    And tb.max = point<3, 3, 3>

  Scenario: Transforming bounds by rotation
    Given b ← bounds<point<-1,-1,-1>, point<1,1,1>>
    And t ← rotation_x<π/4>
    When tb ← b.transform<t>
    Then tb.min = point<-1/1, -√2/1, -√2/1>
    And tb.max = point<1/1, √2/1, √2/1>

  Scenario: Calculating bounds of bounds
    Given b1 ← bounds<point<-1,-1,-1>, point<1,1,1>>
    And b2 ← bounds<point<-1,-4,-1>, point<1,1,3>>
    When bob ← bounds_of_bounds<b1, b2>
    Then bob.min = point<-1, -4, -1>
    And bob.max = point<1, 1, 3>