defmodule Ecto.SeedMigration do
  @moduledoc """
  Collection of helpers for the core seed migration modules.
  """

  @doc """
  Wrap the proper business logic for seed migrations
  """
  defmacro seed_migration(content) do
    quote do
      def up do
        if System.get_env("MIX_ENV") != "test" do
          unquote(content)
        end
      end

      def down do
        if Kernel.function_exported?(__MODULE__, :down_implementation, 0) do
          Kernel.apply(__MODULE__, :down_implementation, [])
        else
          raise "Seed migration can't be rolled back, such migration should implement &down_implementation/0"
        end
      end
    end
  end
end
