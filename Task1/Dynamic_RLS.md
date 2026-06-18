# Task 1 - Advanced DAX (Dynamic RLS)

## Requirement

Allow a logged-in manager to see:

- Their own data
- Direct reports
- Indirect reports

## DAX Expression

```DAX
VAR CurrentEmployeeKey =
    LOOKUPVALUE (
        dim_employee[EmployeeKey],
        dim_employee[EmployeeEmail],
        USERPRINCIPALNAME()
    )

RETURN
    PATHCONTAINS (
        dim_employee[ParentPath],
        CurrentEmployeeKey
    )
```

## Explanation

USERPRINCIPALNAME() retrieves the logged-in user's email.

LOOKUPVALUE() finds the EmployeeKey associated with that email.

PATHCONTAINS() evaluates whether the manager exists within the employee hierarchy path.

This grants visibility to all descendants in the hierarchy while preserving security.
