def create_hours_report(num_days, total_hours, day_limits):
    min_total_hours = sum(min_hours for min_hours, _ in day_limits)
    max_total_hours = sum(max_hours for _, max_hours in day_limits)

    # Checking if the total hours fall within the limits
    if total_hours < min_total_hours or total_hours > max_total_hours:
        print("NO")
        return

    remaining_hours = total_hours
    hours_report = []

    # Pre-calculate min_total_hours and max_total_hours
    precalculated_min_total_hours = min_total_hours
    precalculated_max_total_hours = max_total_hours

    # Generating the report using greedy approach.

    for i, (min_hours, max_hours) in enumerate(day_limits[:-1]):

        # Calculating the allocated hours based on the remaining hours and limits
        allocated_hours = min(
            max(min_hours, remaining_hours // (num_days - i - 1)), max_hours
        )

        # Updating the remaining hours
        remaining_hours -= allocated_hours

        # Adding allocated hours to the report
        hours_report.append(allocated_hours)

    # Allocating the remaining hours to the last day
    hours_report.append(max(min_hours, remaining_hours))

    print("YES")
    print(*hours_report)


num_days = int(input())
total_hours = int(input())
day_limits = []

for i in range(num_days):
    min_hours, max_hours = map(int, input(f"Enter the minimum and maximum hours for day {i+1} separated by space: ").split())
    day_limits.append((min_hours, max_hours))

create_hours_report(num_days, total_hours, day_limits)
