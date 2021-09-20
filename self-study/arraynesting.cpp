#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

int arrayNesting(vector<int> &nums)
{
    vector<bool> visited;
    int ans = 0;
    for (int i = 0; i < nums.size(); i++)
    {
        visited.push_back(false);
    }
    for (int i = 0; i < nums.size(); i++)
    {
        if (visited[i] == false)
        {
            int start = nums[i], count = 0;
            do
            {
                start = nums[start];
                count++;
                visited[start] = true;
            } while (start != nums[i]);
            ans = max(ans, count);
        }
    }
    return ans;
}

int main()
{
    vector<int> nums;
    int n, x;
    cout << "Enter the size: ";
    cin >> n;
    cout << "Enter the elements: ";
    for (int i = 0; i < n; i++)
    {
        cin >> x;
        nums.push_back(x);
    }
    cout << arrayNesting(nums);
}