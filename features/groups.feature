Feature: Groups

Scenario: Creating a new group
  Given g ← group<>
  Then g.transform = identity_matrix
    And g is empty

Scenario: Adding a child to a group
  Given g ← group<>
    And s ← test_shape<>
  When add_child<g, s>
  Then g is not empty
    And g includes s
    And s.parent = g

Scenario: Intersecting a ray with an empty group
  Given g ← group<>
    And r ← ray<point<0, 0, 0>, vector<0, 0, 1>>
  When xs ← local_intersect<g, r>
  Then xs is empty

Scenario: Intersecting a ray with a nonempty group
  Given g ← group<>
    And s1 ← sphere<>
    And s2 ← sphere<>
    And set_transform<s2, translation<0, 0, -3>>
    And s3 ← sphere<>
    And set_transform<s3, translation<5, 0, 0>>
    And add_child<g, s1>
    And add_child<g, s2>
    And add_child<g, s3>
  When r ← ray<point<0, 0, -5>, vector<0, 0, 1>>
    And xs ← local_intersect<g, r>
  Then xs.count = 4
    And xs[0].object = s2
    And xs[1].object = s2
    And xs[2].object = s1
    And xs[3].object = s1

Scenario: Intersecting a transformed group
  Given g ← group<>
    And set_transform<g, scaling<2, 2, 2>>
    And s ← sphere<>
    And set_transform<s, translation<5, 0, 0>>
    And add_child<g, s>
  When r ← ray<point<10, 0, -10>, vector<0, 0, 1>>
    And xs ← intersect<g, r>
  Then xs.count = 2

  Scenario: Bounds for an empty group
    Given g ← group<>
    When bounds ← g.bounds
    Then bounds.min = bounds.max

  Scenario: Bounds for a non-empty group
    Given g ← group<>
      And c1 ← test_cube
      And set_transform<c1, rotation_x<π/4>>
      And add_child<g, c1>
    When tb ← g.bounds
    Then tb.min = point<-1/1, -√2/1, -√2/1>
      And tb.max = point<1/1, √2/1, √2/1>

  Scenario: Bounds for a group of translated spheres
    Given g ← group<>
      And s1 ← sphere<>
      And s2 ← sphere<>
      And set_transform<s2, translation<0, 0, -3>>
      And s3 ← sphere<>
      And set_transform<s3, translation<5, 0, 0>>
      And add_child<g, s1>
      And add_child<g, s2>
      And add_child<g, s3>
    When bounds ← g.bounds
    Then bounds.min = point<-1, -1, -4>
      And bounds.max = point<6, 1, 1>

  Scenario: Bounds for a group containing translated spheres and non truncated cylinders
    Given g ← group<>
    And s1 ← sphere<>
    And s2 ← sphere<>
    And set_transform<s2, translation<0, 0, -3>>
    And c ← test_cylinder
    And add_child<g, s1>
    And add_child<g, s2>
    And add_child<g, c>
    When bounds ← g.bounds
    Then bounds.min = point<-1, -∞, -4>
    And bounds.max = point<1, ∞, 1>