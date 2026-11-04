sampler2D DiffuseSampler : register(s0);
float4 gShadowParam14151617 : register(c53);
float4 globalScalars : register(c35);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0.x = 0.01 + -i.texcoord1.z;
	r0.y = abs(gShadowParam14151617.x);
	r0 = (-r0.y >= 0) ? r0.x : 0;
	clip(r0);
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.w = r0.w * globalScalars.x;
	o.xyz = i.texcoord1.www;

	return o;
}
