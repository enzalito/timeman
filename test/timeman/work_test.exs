defmodule Timeman.WorkTest do
  use Timeman.DataCase

  alias Timeman.Work

  describe "workingtime" do
    alias Timeman.Work.WorkingTime

    import Timeman.WorkFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtime/0 returns all workingtime" do
      working_time = working_time_fixture()
      assert Work.list_workingtime() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Work.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2024-10-07 15:07:00], end: ~N[2024-10-07 15:07:00]}

      assert {:ok, %WorkingTime{} = working_time} = Work.create_working_time(valid_attrs)
      assert working_time.start == ~N[2024-10-07 15:07:00]
      assert working_time.end == ~N[2024-10-07 15:07:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~N[2024-10-08 15:07:00], end: ~N[2024-10-08 15:07:00]}

      assert {:ok, %WorkingTime{} = working_time} = Work.update_working_time(working_time, update_attrs)
      assert working_time.start == ~N[2024-10-08 15:07:00]
      assert working_time.end == ~N[2024-10-08 15:07:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_working_time(working_time, @invalid_attrs)
      assert working_time == Work.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Work.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Work.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Work.change_working_time(working_time)
    end
  end
end
