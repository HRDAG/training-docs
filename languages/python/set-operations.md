### Set operations in python
Set objects are useful for a number of reasons, and they come with some useful operations that can be handy in exploring relational data.

#### Features
In the simplest case, let's say we are iterating through some data and we want to capture all unique values we find that meet a particular condition.

If we use a `list`, we will see the lowest overhead to append a new item, [O(1)](https://wiki.python.org/moin/TimeComplexity) , but we will have to deduplicate the list contents after building the collection.

If we use a `dict`, we will see decent

**Note**: Because you don't have to use the name of an object to declare it in python, and sets and dicts both use {} to denote themselves, python makes an inference at runtime as to which type is intended, based on the structure of the first insertion. Since it wants to run the most efficiently, it will choose the lesser overhead `set` over `dict` unless it gets specific instructions otherwise.
As an example of this issue, let's say we want to use a dictionary as a template for the info we want to capture.
`info = {'name', 'address', 'phone'}`
What's wrong with this implementation? What is going to happen when we run `info['name'] = 'Kenny'`?
`TypeError: 'set' object does not support item assignment`
Instead, when we want to outline the keys a dictionary should have before we have corresponding values, we need to insert a placeholder value for each key so that the compiler leaves room for incoming values.

#### Functions
Several operations are available to use that come with statistical context and 
