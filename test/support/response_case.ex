defmodule IntercomX.ResponseCase do
  use ExUnit.CaseTemplate

  def data(resource) do
    File.read!(Path.expand(__ENV__.file <> "/../fixtures/" <> resource <> ".json"))
  end

  using do
    quote do
      def fixture(resource, type) do
        IntercomX.ResponseCase.data(resource)
        |> type.process_response_body()
      end
    end
  end
end

