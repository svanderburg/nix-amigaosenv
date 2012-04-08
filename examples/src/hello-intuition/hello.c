#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>

#include <stdio.h>

#define INTUITION_VERSION 37

struct Library *IntuitionBase = NULL;

struct TagItem win_tags[] = {
    {WA_Left, 20},
    {WA_Top, 20},
    {WA_Width, 300},
    {WA_Height, 120},
    {WA_CloseGadget, TRUE},
    {WA_Title, "Hello world!"},
    {WA_IDCMP, IDCMP_CLOSEWINDOW},
    {TAG_DONE, NULL}
};

void handle_window_events(struct Window *window)
{
    WaitPort(window->UserPort);
}

int main(int argc, char *argv[])
{
    IntuitionBase = OpenLibrary("intuition.library", INTUITION_VERSION);
    
    if(IntuitionBase == NULL)
    {
	fprintf(stderr, "Error opening intuition library!\n");
	return 1;
    }
    else
    {
	struct Window *window = OpenWindowTagList(NULL, win_tags);
	
	if(window == NULL)
	    fprintf(stderr, "Window failed to open!\n");
	else
	{
	    handle_window_events(window);
	    
	    CloseWindow(window);
	}
    
	CloseLibrary(IntuitionBase);
	return 0;
    }
}
