float4 gShadowParam14151617 : register(c53);

float4 main(float4 texcoord1 : TEXCOORD1) : COLOR
{
	float4 o;

	float4 r0;
	r0.x = 0.01 + -texcoord1.z;
	r0.y = abs(gShadowParam14151617.x);
	r0 = (-r0.y >= 0) ? r0.x : 0;
	clip(r0);
	o = texcoord1.w;

	return o;
}
