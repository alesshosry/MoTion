## Description

MoTion is a new object pattern matcher in Pharo. A pattern matcher works on a finit set of objects that we will call a model. Examples of  models are: the Pharo AST of a method, the DOM of an XML document, the objects loaded from a JSON file,. . .
MoTion can deal with Pharo objects independently of the model containing the data. 
MoTion combines both features for graph pattern matching and object matching, and by that it enables expressing patterns declaratively and applying matches over complex object structures.

## Installation
To install MoTion, go to the Playground (`Ctrl+OW`) in your Pharo image and execute the following Metacello script (select it and press Do-it button or `Ctrl+D`):

```Smalltalk
Metacello new
    baseline: 'MoTion';
    repository: 'github://AlessHosry/MoTion:main';
    load.
```

## Syntax

Multiple operators are used to help developers creating MoTion patterns.
1. Literals are declared the way they are in Pharo like ’A sample text here’ asMatcher and 1 asMatcher. 
Literal patterns match exactly their literal value. This is useful for specifying the value that a property of an object must have.
2. The “<=>” operator is a sort of generic matcher. It tries to match its left hand side (lhs) with the pattern on its right hand side (rhs).
As noted before, it is a polymorphic operator depending on the lhs. If the lhs is an object, it tries to match this object with the rhs. If the lhs is a
collection, it tries to match any element of the collection with the rhs.
3. To define an object pattern, one specifies its type using the class name followed by the “\% {}” operator like in: ClassA \% {} . The class expected comes before “\% {}” and property values can be specified between the curly braces (see below).
4. A similar operator: “\%\% {}” is used to match a class or any of its subclasses.
5. These two operators can express sub-patterns on the properties of the matched object. They are specified between the curly braces. Object properties are instance variable accessors. The curly braces act as a conjunction of sub-patterns specifying the value a property should match. It can be seen as a Logical matcher.
ClassA \% {
#’property1’ <=> aValue1.
#’property2’ <=> aValue2.
}
This pattern matches an object of class ClassA, with a property property1 having the value aValue1 and property2 having the value aValue2.
The sub-patterns could also be more complex (see bellow, Structural pattern).


