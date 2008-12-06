
Affirm do(
  DescribeContext = Origin mimic do(
    create = method(
      newSelf = mimic
      newSelf specs = []
      newSelf)

    stackTraceAsText = method(
      "#{code filename}:#{code line}:#{code position}"
    )

    fullName = method(
      "returns the name of this context, prepended with the surrounding names",
      if(cell?(:surrounding),
        "#{surrounding fullName} #{describesWhat}",
        describesWhat))

    run = method(
      "runs all the defined descriptions and specs",
      reporter,
      
      reporter addExampleGroup(self)
      success = true
      specs each(n,
        insideSuccess = if(n first == :description,
          n second run(reporter),
          Affirm runTest(self, n second, n third, reporter))
        if(success, success = insideSuccess))
      success
    )

    it = macro(
      "takes one text argument, and one optional code argument. if the code argument is left out, this spec will be marked as pending",
      if(call arguments length == 1,
        self specs << [:pending, call argAt(0)],
        self specs << [:test, call argAt(0), call arguments second])
    )
  )
)