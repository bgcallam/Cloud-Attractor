/**
 * This class implements a version of the
 * quicksort algorithm using a partition
 * algorithm that does not rely on the
 * first element of the array being vacant,
 * nor does it guarantee that the chosen
 * pivot value is at the split point of
 * the partition.
 * 
 * @author Cay Horstmann
 */
public class QuickAreaBlobSort
{
  public QuickAreaBlobSort(AreaBlob[] anArray)
  {
    a = anArray;
  }

  /**
   * Sorts the array managed by this sorter
   */
  public AreaBlob[] sort()
  {
    sort(0, a.length - 1);
    return (AreaBlob[])reverse(a);
  }

  public AreaBlob[] sort(int low, int high)
  {
    if (low >= high) return (AreaBlob[])reverse(a);
    int p = partition(low, high);
    sort(low, p);
    sort(p + 1, high);
    return (AreaBlob[])reverse(a);
  }

  private int partition(int low, int high)
  {
    // First element
    float pivot = a[low].getArea();

    // Middle element
    //int middle = (low + high) / 2;
    //int pivot = a[middle];

    int i = low - 1;
    int j = high + 1;
    while (i < j)
    {
      i++; 
      while (a[i].getArea() < pivot) i++;
      j--; 
      while (a[j].getArea() > pivot) j--;
      if (i < j) swap(i, j);
    }
    return j;
  }

  /**
   * Swaps two entries of the array.
   * @param i the first position to swap
   * @param j the second position to swap
   */
  private void swap(int i, int j)
  {
    AreaBlob temp = a[i];
    a[i] = a[j];
    a[j] = temp;
  }

  private AreaBlob[] a;
}

class AreaBlob{
  Blob theBlob;
  float theArea;

  AreaBlob(Blob b){
    theBlob = b;
    theArea = b.w * b.h;
  } 
  
  Blob getBlob(){
    return theBlob;
  }
  
  float getArea(){
     return theArea; 
  }

}
