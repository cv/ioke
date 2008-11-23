include_class('ioke.lang.Runtime') { 'IokeRuntime' } unless defined?(IokeRuntime)

import Java::java.io.StringReader unless defined?(StringReader)
import Java::java.io.PrintWriter unless defined?(PrintWriter)
import Java::java.io.StringWriter unless defined?(StringWriter)
import Java::java.io.InputStreamReader unless defined?(InputStreamReader)
import Java::java.lang.System unless defined?(System)

describe "Base" do 
  describe "'mimic'" do 
    it "should be able to mimic Origin" do 
      ioke = IokeRuntime.get_runtime()
      result = ioke.evaluate_stream(StringReader.new(%q[Origin mimic]))
      result.find_cell(nil,nil, 'kind').data.text.should == 'Origin'
      result.should_not == ioke.origin
    end

    it "should be able to mimic Ground" do 
      ioke = IokeRuntime.get_runtime()
      result = ioke.evaluate_stream(StringReader.new(%q[Ground mimic]))
      result.find_cell(nil,nil, 'kind').data.text.should == 'Ground'
      result.object_id.should_not == ioke.ground.object_id
    end

    it "should be able to mimic Base" do 
      ioke = IokeRuntime.get_runtime()
      result = ioke.evaluate_stream(StringReader.new(%q[Base mimic]))
      result.find_cell(nil,nil, 'kind').data.text.should == 'Base'
      result.should_not == ioke.base
    end

    it "should be able to mimic Text" do 
      ioke = IokeRuntime.get_runtime()
      result = ioke.evaluate_stream(StringReader.new(%q[Text mimic]))
      result.find_cell(nil,nil, 'kind').data.text.should == 'Text'
      result.object_id.should_not == ioke.text.object_id
    end

    it "should not be able to mimic DefaultBehavior" do 
      sw = StringWriter.new(20)
      out = PrintWriter.new(sw)

      ioke = IokeRuntime.get_runtime(out, InputStreamReader.new(System.in), out)
      begin
        ioke.evaluate_stream(StringReader.new(%q[DefaultBehavior mimic]))
        true.should be_false
      rescue NativeException => cfe
        cfe.cause.value.find_cell(nil, nil, "kind").data.text.should == "Condition Error NoSuchCell"
      end
    end

    it "should not be able to mimic nil" do 
      sw = StringWriter.new(20)
      out = PrintWriter.new(sw)

      ioke = IokeRuntime.get_runtime(out, InputStreamReader.new(System.in), out)

      begin
        ioke.evaluate_stream(StringReader.new(%q[nil mimic]))
        true.should be_false
      rescue NativeException => cfe
        cfe.cause.value.find_cell(nil, nil, "kind").data.text.should == "Condition Error CantMimicOddball"
      end
    end
  end
end
